package decompiler.tags.doabc.instruction
{
	import decompiler.utils.SWFUtil;
	import decompiler.utils.SWFXML;
	
	import flash.utils.ByteArray;

	/**
	 * Format
		debugline
		linenum
	 * linenum is a u30 that indicates the current line 
	 * number the debugger should be using for the code currently executing. 
	 * Adobe ActionScript Virtual Machine 2 (AVM2) 
	 * Overview 54 If the debugger is running, 
	 * then this instruction sets the current line number in the debugger. 
	 * This lets the debugger know which instructions 
	 * are associated with each line in a source file. 
	 * The debugger will treat all instructions as occurring 
	 * on the same line until a new debugline opcode is encountered.
	 * @author ukyohpq
	 * 
	 */
	public class Debugline extends AbstractInstruction
	{
		private var _linenum:uint;

		public function get linenum():uint
		{
			return _linenum;
		}

		public function set linenum(value:uint):void
		{
			modify();
			_linenum = value;
		}

		public function Debugline()
		{
			super();
		}
		
		override public function getForm():int
		{
			return 240;
		}
		
		override public function getName():String
		{
			return "debugline";
		}
		
		override protected function pcodeDecodeFromBytes(byte:ByteArray):void
		{
			_linenum = SWFUtil.readU30(byte);
		}
		
		
		
		override protected function encodeBody(byte:ByteArray):void
		{
			SWFUtil.writeU30(byte, _linenum);
		}
		
//		override public function toString():String
//		{
//			return "[ debugline linenum:" + linenum + " ]";
//		}
		
		override protected function stringBody():String
		{
			return "linenum:" + _linenum;
		}
		
		override public function getParams():Vector.<int>
		{
			return new <int>[_linenum];
		}
		
		override public function getParamNames():Vector.<String>
		{
			return new <String>["_linenum"];
		}
		
		override protected function paramsToXML(xml:SWFXML):void
		{
			xml.appendChild("<linenum>" + _linenum + "</linenum>");
		}
	}
}