package decompiler.tags.doabc.instruction
{
	import decompiler.tags.doabc.reference.Reference;
	import decompiler.utils.SWFUtil;
	import decompiler.utils.SWFXML;
	
	import flash.utils.ByteArray;

	/**
	 * Format
		getproperty
		index
	 * 	index is a u30 that must be an index into the multiname constant pool. If the multiname at
		that index is a runtime multiname the name and/or namespace will also appear on the stack
		so that the multiname can be constructed correctly at runtime.
		The property with the name specified by the multiname will be resolved in object, and the
		value of that property will be pushed onto the stack. If the property is unresolved,
		undefined is pushed onto the stack. See “Resolving multinames” on page 10.
	 * @author ukyohpq
	 * 
	 */
	public class Getproperty extends AbstractInstruction
	{
		private var _index:uint;

		public function get index():uint
		{
			return _index;
		}

		public function set index(value:uint):void
		{
			modify();
			try{
				$abcFile.getMultinameByIndex(_index).removeReference(this, "index");
			}catch(err:Error)
			{
				trace(err);
			}
			_index = value;
			$abcFile.getMultinameByIndex(_index).addReference(this, "index");
		}

		public function Getproperty()
		{
			super();
		}
		
		override protected function pcodeDecodeFromBytes(byte:ByteArray):void
		{
			_index = SWFUtil.readU30(byte);
		}
		
		override public function creatRefrenceRelationship():void
		{
			$abcFile.getMultinameByIndex(_index).addReference(this, "index");
		}
		
		
		override protected function encodeBody(byte:ByteArray):void
		{
			SWFUtil.writeU30(byte, _index);
		}
		
		override public function getForm():int
		{
			return 102;
		}
		
		override public function getName():String
		{
			return "getproperty";
		}
		
//		override public function toString():String
//		{
//			return "[ getproperty name:" + $abcFile.getMultinameByIndex(index) + " ]";
//		}
		
		override protected function stringBody():String
		{
			return "name:mn(" + _index + ")";
//			return "name:" + $abcFile.getMultinameByIndex(_index);
		}
		
		override public function getParams():Vector.<int>
		{
			return new <int>[_index];
		}
		
		override public function getParamNames():Vector.<String>
		{
			return new <String>["_index"];
		}
		
		override protected function paramsToXML(xml:SWFXML):void
		{
			xml.appendChild("<index>" + _index + "</index>");
		}
		
		override public function setProperty(name:String, value:Object, refreshReference:Boolean=true):void
		{
			include "../reference/IReferenceable_Fragment_1.as";
		}
		
		override public function deltaNumStack():int
		{
			return -$abcFile.getMultinameByIndex(_index).needNumParams();
		}
	}
}