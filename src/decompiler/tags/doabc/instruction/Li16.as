package decompiler.tags.doabc.instruction
{
	/**
	 * Format
		li16
	 * Pop offset off of the stack.  
	 * The offset's value must lie between 0 and 
	 * the size of the ByteArray which is the Domain's current domainMemory property. 
	 * Push the 16-bit value at that offset in the ByteArray onto the stack.
	 * @author ukyohpq
	 * 
	 */
	public class Li16 extends AbstractInstruction
	{
		public function Li16()
		{
			super();
		}
		
		override public function getForm():int
		{
			return 54 ;
		}
		
		override public function getName():String
		{
			return "li16";
		}
		
		
	}
}