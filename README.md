# suzuri-actionscript-client

A wrapper around the [v1 SUZURI API](https://suzuri.jp/developer).

## Dependencies

* [charlesbihis/actionscript-oauth2](https://github.com/charlesbihis/actionscript-oauth2)
* [as3crypto](https://code.google.com/p/as3crypto/)

## Usage

Authorization

```actionscript
import jp.suzuri.SuzuriClient;
import jp.suzuri.events.SuzuriAuthorizedEvent;
import jp.suzuri.events.SuzuriResponseEvent;

var webView:StageWebView = new StageWebView();
webView.viewPort = new Rectangle(0, 0, this.stage.width, this.stage.height);

var suzuriClient:SuzuriClient = new SuzuriClient(
	webView, 
	"YOUR CLIENT ID",
	"YOUR CLIENT SECRET",
	
    // YOUR REDIRECT URL
    // For Air, and not redirected
	"https://suzuri.jp/tosute"
);

// Authorized callback
suzuriClient.addEventListener(SuzuriAuthorizedEvent.TYPE, function(event:SuzuriAuthorizedEvent) {
	if (event.errorCode == null) {
		trace("--> aurhotized!! accessToken: " + suzuriClient.accessToken);
	} else {
		trace(event.errorMessage);
	}
	webView.stage = null;
});


// Authorization call
if (accessToken) {
  // No authentication is required if there is an access token. (or API KEY)
  suzuriClient.accessToken = accessToken;
} else {
  suzuriClient.authorize();
}
```

API Call Example

```actionscript
// All Request dispatch event for SuzuriResponeEvent
suzuriClient.addEventListener(SuzuriResponseEvent.TYPE, function(event:SuzuriResponseEvent) {
	var body:Object = event.body;
	
	if (event.success) {
		if (body.material) {
			trace("==> material id: " + body.material.id);
			trace("==> title: " + body.products[0].title);
			trace("==> description: " + body.products[0].description);
			trace("==> sampleImageUrl: " + body.products[0].sampleImageUrl);
			trace("==> sampleUrl:" + body.products[0].sampleUrl);
		} else if (body.user) {
			trace("==> name: " + body.user.name);
		}
		var material = event.body.material;
		trace(event.body);
	} else {
		// エラー
		trace(event.body);
	}
});


var attributes = {
	title: "チャメ林チョメ夫",
	description: "めちゃストイックやしめちゃ夜とかに修行してるしめちゃ自己啓発本とかも読む侍をプリントしました",
	products: [
		{ 
			itemId: 1,             // 1 = t-shirt
			published: true,       // 
			resizeMode: "contain"  // "contain" = Scale the image to the largest size such that both its width and its height can fit inside the t-shirt print area
		}
	]
};
suzuriClient.createMaterialFromBitmapData(bitmapdata, attributes);
```

### Create Material Interface

* `createMaterialFromBitmapData(bitmapData:BitmapData, attributes:Object)`
* `createMaterialFromBitmapData(png:ByteArray, attributes:Object)`

### Generic Requests

suzuri-actionscript-client has get, post, put, and delete functions which can make requests with the specified HTTP method to any endpoint.

```actionscript
suzuriClient.request(URLRequestMethod.PUT, 'materials/' + materialID, { price: 500 })
```

### Reference

* See api reference more detail https://suzuri.jp/developer/documentation/v1
