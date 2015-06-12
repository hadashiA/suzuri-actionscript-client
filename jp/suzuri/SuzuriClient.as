package jp.suzuri {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
    import flash.media.StageWebView;
    import flash.utils.ByteArray;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLRequestHeader;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
	import flash.display.BitmapData;

	import org.as3commons.logging.setup.LogSetupLevel;

    import com.adobe.protocols.oauth2.OAuth2;
    import com.adobe.protocols.oauth2.grant.AuthorizationCodeGrant;
    import com.adobe.protocols.oauth2.event.GetAccessTokenEvent;

    import com.adobe.images.PNGEncoder;
    import com.hurlant.util.Base64;
	
    import jp.suzuri.events.SuzuriAuthorizedEvent;
    import jp.suzuri.events.SuzuriResponseEvent;

	public class SuzuriClient extends EventDispatcher {
        public var accessToken:String;

        private var oauth:OAuth2;
        private var grant:AuthorizationCodeGrant;
        private var lastStatusCode;

		public function SuzuriClient(
            stageWebView:StageWebView,
            clientId:String,
            clientSecret:String,
            redirectUri:String,
            scope:String = "read write") {

            this.oauth = new OAuth2(
                'https://suzuri.jp/oauth/authorize',
                'https://suzuri.jp/oauth/token',
                LogSetupLevel.ALL
            );

            this.grant = new AuthorizationCodeGrant(stageWebView,
                clientId, clientSecret, redirectUri, scope
            );

            this.oauth.addEventListener(GetAccessTokenEvent.TYPE, this.onGetAccessToken);
		}

        public function authorized():Boolean {
            return this.accessToken != null && this.accessToken.length > 0;
        }

        public function authenticate():void {
            this.oauth.getAccessToken(this.grant);
        }

        public function createMaterialFromBitmapData(data:BitmapData, attributes:Object):void {
	        var bytes:ByteArray = PNGEncoder.encode(data);
            this.createMaterialFromPNG(bytes, attributes);
        }

        public function createMaterialFromPNG(bytes:ByteArray, attributes:Object):void {
	        var dataUrl:String = "data:image/png;base64," + Base64.encodeByteArray(bytes);
            attributes.texture = dataUrl;
            this.request(URLRequestMethod.POST, 'materials', attributes)
        }

        public function request(method:String, path:String, attributes:Object):void {
            if (!this.authorized()) {
                throw new Error("Unauthorized");
            } 

            var urlLoader = new URLLoader();
            var request = new URLRequest();
	        var authorization:URLRequestHeader = new URLRequestHeader(
                "Authorization", "Bearer " + this.accessToken);
            request.url = 'https://suzuri.jp/api/v1/' + path;
            request.method = method;
            request.requestHeaders = [authorization];
            request.contentType = "application/json";
            request.data = JSON.stringify(attributes);

            urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
            urlLoader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS, this.onResponse);
            urlLoader.addEventListener(Event.COMPLETE, this.onResponseBody);
            urlLoader.addEventListener(IOErrorEvent.IO_ERROR, this.onResponseError);
	        urlLoader.load(request);
        }

        public function onGetAccessToken(event:GetAccessTokenEvent):void {
            var newEvent = new SuzuriAuthorizedEvent(
                event.errorCode, event.errorMessage, event.accessToken
            )
            this.accessToken = event.accessToken;
            this.dispatchEvent(newEvent);
        }

        public function onResponse(event:HTTPStatusEvent):void {
            var urlLoader:URLLoader;

            this.lastStatusCode  =  event.status;
            if (event.status < 200 || event.status > 200) {
                urlLoader = event.target as URLLoader;
                this.dispatchEvent(new SuzuriResponseEvent(event.status, urlLoader.data));
            }
        }

        public function onResponseBody(event:Event):void {
            var urlLoader:URLLoader = event.target as URLLoader;
            var body:String = urlLoader.data;
            this.dispatchEvent(new SuzuriResponseEvent(this.lastStatusCode, body));
            this.lastStatusCode = null;
        }

        public function onResponseError(event:IOErrorEvent):void {
            var body:String = urlLoader.data;
            this.dispatchEvent(new SuzuriResponseEvent(500, event.text));
            this.lastStatusCode = null;
        }
	}
}
