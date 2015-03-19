package jp.suzuri.events {
    import flash.events.Event;

    public class SuzuriAuthorizedEvent extends Event {
        public static const TYPE:String = "suzuriAuthorized";

        private var _errorCode:String;
        private var _errorMessage:String;
        private var _accessToken:String;

        public function SuzuriAuthorizedEvent(
            errorCode:String,
            errorMessage:String,
            accessToken:String,
            bubbles:Boolean = false, cancelable:Boolean = false) {

            super(TYPE, bubbles, cancelable);
            _errorCode = errorCode;
            _errorMessage = errorMessage;
            _accessToken = accessToken;
        }

        public function get errorCode():String {
            return _errorCode;
        }

        public function get errorMessage():String {
            return _errorMessage;
        }

        public function get accessToken():String {
            return _accessToken;
        }
    }
}