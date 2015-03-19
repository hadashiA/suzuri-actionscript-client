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
			// サンプルに含まれてないですが、たとえば、ユーザ情報取得APIを叩くとこんなかんじでデータがはいってます。
			trace("==> name: " + body.user.name);
		}
		var material = event.body.material;
		trace(event.body);
	} else {
		// エラー
		trace(event.body);
	}
});

if (accessToken) {
  suzuriClient.accessToken = accessToken;
} else {
  suzuriClient.authorize();
}
```

### API Call Example

```
var attributes = {
	title: "商品の名前を入れる",
	description: "商品の説明を入れる",
	products: [
		{ 
			itemId: 1, // 1=Ｔシャツ
			published: true,   // true=公開状態になる
			resizeMode: "contain"  // "contain" = 自動で拡大
		}
	]
};
suzuriClient.createMaterialFromBitmapData(bitmapdata, attributes);
```
