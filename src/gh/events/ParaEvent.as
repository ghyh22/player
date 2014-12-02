package gh.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author gonghao
	 */
	public class ParaEvent extends Event 
	{
		public var para:Object;
		public function ParaEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			para = { };
		} 
		
		public override function clone():Event 
		{ 
			var event:ParaEvent = new ParaEvent(type, bubbles, cancelable);
			for (var tmp:Object in this.para) {
				event.para[tmp] = this.para[tmp];
			}
			return event;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ParaEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}