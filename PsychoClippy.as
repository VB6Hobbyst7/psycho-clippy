package {
	import com.adobe.serialization.json.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
	public class PsychoClippy extends Sprite {
		[Embed(source="../../clippy.png")]
		private var Clippy:Class
		
		private var s:Socket
		
		public function PsychoClippy(){
			frame1()
			psychoInit()
			addEventListener(AttentionEvent.ATTENTION, onAttention)
		}
		
		private function onAttention(e:AttentionEvent):void {
			trace('AttentionEvent: ', e.attentionLevel)
		}
		
		private function psychoInit():void {
			s = new Socket
			s.connect('127.0.0.1', 13854)
			s.addEventListener(Event.CONNECT, onConnect)
			s.addEventListener(ProgressEvent.SOCKET_DATA, onData)
		}
		
		private function onConnect(e:Event):void {
			s.writeUTFBytes('{ "enableRawData": false, "format": "Json" }\r')
			s.flush()
		}
		
		private function onData(e:ProgressEvent):void {
			var data:String = s.readUTFBytes(s.bytesAvailable)
			var lines:Array = data.split('\r')
			for(var i:int = 0; i < lines.length; i++){
				var str:String = lines[i]
				if(str.length <= 1) return
				var json:* = JSON.decode(str, false)
				if(json.eSense){
					if(json.eSense.attention){
						dispatchEvent(new AttentionEvent(AttentionEvent.ATTENTION, false, false, json.eSense.attention))
					}
				}
			}
		}
		
		public function frame1():void {
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			
			var c:DisplayObject = new Clippy
			addChild(c)
			
			trace('!!', c.width, c.height)
			
			var nw:NativeWindow = stage.nativeWindow
			nw.x = 0
			nw.y = 0
			nw.width = c.width
			nw.height = c.height + 20
			
			var wx:int = Capabilities.screenResolutionX
			var wy:int = Capabilities.screenResolutionY
			
			setInterval(change, 2000)
			
			var destX:int, destY:int
			var sX:int, sY:int
			
			function change():void {
				destX = Math.floor(Math.random() * (wx - nw.width))
				destY = Math.floor(Math.random() * (wy - nw.height))
				sX = nw.x
				sY = nw.y
			}
			
			addEventListener(Event.ENTER_FRAME, oef)
			
			function oef(e:Event):void {
				nw.x += (1 / (stage.frameRate * 2)) * (destX - sX)
				nw.y += (1 / (stage.frameRate * 2)) * (destY - sY)
			}
		}
	}
}