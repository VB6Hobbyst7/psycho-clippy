package {
	import com.adobe.serialization.json.*
	
	import flash.display.*
	import flash.events.*
	import flash.net.*
	import flash.system.*
	import flash.text.*
	import flash.utils.*
	
	public class PsychoClippy extends Sprite {
		[Embed(source="../../clippy.png")]
		private var Clippy:Class
		
		private var s:Socket,
					nw:NativeWindow,
					c:DisplayObject,
					t:TextField
		
		public function PsychoClippy(){
			init()
			psychoInit()
			addEventListener(AttentionEvent.ATTENTION, onAttention)
		}
		
		public function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE
			stage.align = StageAlign.TOP_LEFT
			
			c = new Clippy
			addChild(c)
			
			nw = stage.nativeWindow
			//nw.x = 0
			//nw.y = 0
			
				
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown)
			
			t = new TextField
			t.text = 'It looks like you\'re not paying attention.\nWould you like to order coffee?'
			t.textColor = 0
			t.background = true
			t.backgroundColor = 0xfeff97
			t.width = 400
			t.height = 250
			t.wordWrap = true
			t.multiline = true
			c.x += t.width
			
			var tf:TextFormat = new TextFormat('Myriad Pro', 47, 0)
			t.setTextFormat(tf)
			addChild(t)
			t.visible = false
			
			nw.width = c.width + t.width
			nw.height = c.height + 30
		}
		
		private function onAttention(e:AttentionEvent):void {
			var attention:uint = e.attentionLevel
			trace('AttentionEvent: ', attention)
			
			if(attention < 50){
				t.visible = true
			} else {
				t.visible = false
			}
		}
		
		private function psychoInit():void {
			s = new Socket
			s.connect('127.0.0.1', 13854)
			s.addEventListener(Event.CONNECT, onConnect)
			s.addEventListener(ProgressEvent.SOCKET_DATA, onData)
			s.addEventListener(IOErrorEvent.IO_ERROR, onSocketError)
		}
		
		private function onConnect(e:Event):void {
			s.writeUTFBytes('{ "enableRawData": false, "format": "Json" }\r')
			s.flush()
		}
		
		private function onMouseDown(e:MouseEvent):void {
			nw.startMove()
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
		
		private function onSocketError(e:IOErrorEvent):void {
			trace('No MindWave detected')
		}
	}
}