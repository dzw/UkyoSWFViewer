package decompiler.tags.doabc.instruction
{
	/**
	 * Format
		pushwith
	 * scope_obj is popped off of the stack, and the object is pushed onto the scope stack. scope_obj can be of
		any type.
	 * @author ukyohpq
	 * 
	 */
	public class Pushwith extends AbstractInstruction
	{
		public function Pushwith()
		{
			super();
		}
		
		override public function getForm():int
		{
			return 28;
		}
		
		override public function getName():String
		{
			return "pushwith";
		}
		
		override public function deltaNumStack():int
		{
			return -1;
		}
		
		override public function deltaNumScope():int
		{
			return 1;
		}
		
	}
}