package
{
	import flash.events.Event;
	
	public class AttentionEvent extends Event
	{
		public static var ATTENTION:String = 'attention'
		public var attentionLevel:uint
		public function AttentionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, att:uint = 0)
		{
			attentionLevel = att
			super(type, bubbles, cancelable);
		}
	}
}