# suzuri-actionscript-client

## Usage

### Authorize Example

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

if (accessToken) {
  suzuriClient.accessToken = accessToken;
} else {
  suzuriClient.authorize();
}
```

### API Call Example

```
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
			itemId: 1, 
			published: true,
			resizeMode: "contain"
		}
	]
};
suzuriClient.createMaterialFromBitmapData(bitmapdata, attributes);
```
