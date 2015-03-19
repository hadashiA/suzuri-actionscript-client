package jp.suzuri.events {
    import flash.events.Event;

    public class SuzuriResponseEvent extends Event {
        public static const TYPE:String = "suzuriResponse";

        private var _success:Boolean;
        private var _status:Number;
        private var _body:Object;

        public function SuzuriResponseEvent(
            status:Number,
            body:String,
            bubbles:Boolean = false, cancelable:Boolean = false) {
            this._success = (status >= 200 && status < 300);

            this._status = status;
            if (body && body.length > 0) {
                try {
                    this._body = JSON.parse(body);
                } catch (e:TypeError) {}
            }
            super(TYPE, bubbles, cancelable);
        }

        public function get success():Boolean {
            return this._success;
        }

        public function get status():Number {
            return this._status;
        }

        public function get body():Object {
            return this._body;
        }
    }
}