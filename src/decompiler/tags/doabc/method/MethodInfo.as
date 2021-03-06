package decompiler.tags.doabc.method
{
	import decompiler.tags.doabc.ABCFileElement;
	import decompiler.tags.doabc.events.ABCFileEvent;
	import decompiler.tags.doabc.reference.IReferenceable;
	import decompiler.tags.doabc.reference.Reference;
	import decompiler.tags.doabc.reference.ReferencedElement;
	import decompiler.utils.SWFUtil;
	import decompiler.utils.SWFXML;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * The method_info entry defines the signature of a single method
	 * method_info
			{
				u30 param_count
				u30 return_type
				u30 param_type[param_count]
				u30 name
				u8 flags
				option_info options
				(
					option_info
					{
						u30 option_count
						option_detail option[option_count]
					}
				)
				param_info param_names
			}
			 
			flags:
			Name 				Value 		Meaning
	--------NEED_ARGUMENTS 		0x01 		Suggests to the run-time that an “arguments” object (as specified by the
	|										ActionScript 3.0 Language Reference) be created. Must not be used
互斥	|										together with NEED_REST. See Chapter 3.
	|		NEED_ACTIVATION 	0x02 		Must be set if this method uses the newactivation opcode.
	--------NEED_REST 			0x04 		This flag creates an ActionScript 3.0 rest arguments array. Must not be
											used with NEED_ARGUMENTS. See Chapter 3.
			HAS_OPTIONAL 		0x08 		Must be set if this method has optional parameters and the options
											field is present in this method_info structure.
			SET_DXNS 			0x40 		Must be set if this method uses the dxns or dxnslate opcodes.
			HAS_PARAM_NAMES 	0x80 		Must be set when the param_names field is present in this method_info structure.
			 
			option_info
			{
				u30 option_count
				option_detail option[option_count]
			}
	 * @author ukyohpq
	 * 
	 */
	public final class MethodInfo extends ReferencedElement implements IReferenceable
	{
		public function setProperty(name:String, value:Object, refreshReference:Boolean=true):void
		{
			 include "../reference/IReferenceable_Fragment_1.as"
			
		}
		
		private var _returnType:int;

		/**
		 * The return_type field is an index into the multiname array of the constant pool; 
		 * the name at that entry provides the name of the return type of this method. 
		 * A zero value denotes the any (“*”) type
		 */
		public function get returnType():int
		{
			return _returnType;
		}
		
		/**
		 * @private
		 */
		public function set returnType(value:int):void
		{
			modify();
			try{
				$abcFile.getMultinameByIndex(_returnType).removeReference(this, "returnType");
			}catch(err:Error){
				trace(err);
			}
			_returnType = value;
			$abcFile.getMultinameByIndex(_returnType).addReference(this, "returnType");
		}

		private var _paramTypesArr:Vector.<uint>;

		public function get paramTypesArr():Vector.<uint>
		{
			return _paramTypesArr;
		}

		public function setParamTypeAt(value:int, index:int = -1):void
		{
			if(index < 0 || index >= _paramTypesArr.length)
			{
				_paramTypesArr.push(value);
				$abcFile.getMultinameByIndex(value).addReference(this, "paramTypesArr", _paramTypesArr.length - 1);
			}else{
				try{
					$abcFile.getMultinameByIndex(_paramTypesArr[index]).removeReference(this, "paramTypesArr", index);
				}catch(err:Error)
				{
					trace(err);
				}
				_paramTypesArr[index] = value;
				$abcFile.getMultinameByIndex(value).addReference(this, "paramTypesArr", index);
			}
			modify();
		}
		
		private var _needArguments:Boolean;

		public function get needArguments():Boolean
		{
			return _needArguments;
		}

		public function set needArguments(value:Boolean):void
		{
			modify();
			_needArguments = value;
		}

		private var _needActivation:Boolean;

		public function get needActivation():Boolean
		{
			return _needActivation;
		}

		public function set needActivation(value:Boolean):void
		{
			modify();
			_needActivation = value;
		}

		private var _needRest:Boolean;

		public function get needRest():Boolean
		{
			return _needRest;
		}

		public function set needRest(value:Boolean):void
		{
			modify();
			_needRest = value;
		}

		private var _hasOptional:Boolean;

		/**
		 * 是否有可选参数(应该是默认参数)
		 * @return 
		 * 
		 */
		public function get hasOptional():Boolean
		{
			return _hasOptional;
		}

		public function set hasOptional(value:Boolean):void
		{
			modify();
			_hasOptional = value;
		}

		private var _setDXNS:Boolean;

		public function get setDXNS():Boolean
		{
			return _setDXNS;
		}

		public function set setDXNS(value:Boolean):void
		{
			modify();
			_setDXNS = value;
		}

		private var _hasParamNames:Boolean;

		public function get hasParamNames():Boolean
		{
			return _hasParamNames;
		}

		public function set hasParamNames(value:Boolean):void
		{
			modify();
			_hasParamNames = value;
		}

		private var _name:uint;

		/**
		 * The name field is an index into the string array of the constant pool; 
		 * the string at that entry provides the name of this method. 
		 * If the index is zero, this method has no name
		 * 测试发现，这个name已经没有用了，甚至使用超过常量池长度的索引都没问题
		 */
		public function get name():uint
		{
			return _name;
		}

		/**
		 * @private
		 */
		public function set name(value:uint):void
		{
			modify();
			try{
				$abcFile.getStringByIndex(_name).removeReference(this, "name");
			}catch(err:Error)
			{
				trace(err);
			}
			_name = value;
			$abcFile.getStringByIndex(_name).addReference(this, "name");
		}

		private var _optionArr:Vector.<MethodOptionDetail>;
		private var _paramNameArr:Vector.<uint>;

		public function get paramNameArr():Vector.<uint>
		{
			return _paramNameArr;
		}

		public function setParamNameAt(value:int, index:int = -1):void
		{
			if(index < 0 || index >= _paramNameArr.length)
			{
				_paramNameArr.push(value);
				$abcFile.getStringByIndex(value).addReference(this, "paramNameArr", _paramNameArr.length - 1);
			}else{
				$abcFile.getStringByIndex(_paramNameArr[index]).addReference(this, "paramNameArr", index);
				_paramNameArr[index] = value;
				$abcFile.getStringByIndex(value).addReference(this, "paramNameArr", index);
			}
		}
		
		public function MethodInfo(returnType:int = 0, 
								   name:int = 0,
								   needArguments:Boolean = false, 
								   needActivation:Boolean = false,
								   needRest:Boolean = false,
								   hasOptional:Boolean = false,
								   setDXNS:Boolean = false,
								   hasParamNames:Boolean = false)
		{
			_returnType = returnType;
			_name = name;
			_needArguments = needArguments;
			_needActivation = needActivation;
			_needRest = needRest;
			_hasOptional = hasOptional;
			_setDXNS = setDXNS;
			_hasParamNames = hasParamNames;
			
			_paramTypesArr = new <uint>[];
			_optionArr = new <MethodOptionDetail>[];
			_paramNameArr = new <uint>[];
		}
		
		override public function decodeFromBytes(byte:ByteArray):void
		{
			/*The param_count field is the number of formal parameters that the method supports; 
			it also represents the length of the param_type array.*/
			var param_count:int = SWFUtil.readU30(byte);
//			trace("MethodInfo param_count:" + param_count);
			_paramTypesArr.length = param_count;
			_paramNameArr.length = param_count;
			_returnType = SWFUtil.readU30(byte);
//			trace("MethodInfo returnType:" + $abcFile.getMultinameByIndex(_returnType));
			
			for (var i:int = 0; i < param_count; ++i) 
			{
				/*Each entry in the param_type array is an index into the multiname*/
				_paramTypesArr[i] = SWFUtil.readU30(byte);
//				trace("MethodInfo paramTypeIndex:" + i + " paramType:" + $abcFile.getMultinameByIndex(_paramTypesArr[i]));
			}
			_name = SWFUtil.readU30(byte);
//			trace("MethodInfo name:" + $abcFile.getStringByIndex(_name));
			
			var flag:int = byte.readUnsignedByte();
//			trace("MethodInfo flag:" + flag);
			_needArguments = Boolean(flag & 1);
//			trace("MethodInfo needArguments:" + _needArguments);
			_needActivation = Boolean((flag >> 1) & 1);
//			trace("MethodInfo _needActivation:" + _needActivation);
			_needRest = Boolean((flag >> 2) & 1);
//			trace("MethodInfo _needRest:" + _needRest);
			_hasOptional = Boolean((flag >> 3) & 1);
//			trace("MethodInfo _hasOptional:" + _hasOptional);
			_setDXNS = Boolean((flag >> 6) & 1);
//			trace("MethodInfo _setDXNS:" + _setDXNS);
			_hasParamNames = Boolean((flag >> 7) & 1);
//			trace("MethodInfo _hasParamNames:" + _hasParamNames);
			
			//检测_needArguments 和  _needRest的互斥关系
			if(_needArguments && _needRest) throw new Error("NEED_ARGUMENTS 和 NEED_RESET 应该是互斥的");
			
			if(_hasOptional)
			{
				//option_count
				var option_count:int = SWFUtil.readU30(byte);
				_optionArr.length = option_count;
				for (i = 0; i < option_count; ++i) 
				{
					var optionDetail:MethodOptionDetail = $abcFile.elementFactory(MethodOptionDetail) as MethodOptionDetail;
					optionDetail.decodeFromBytes(byte);
					_optionArr[i] = optionDetail;
				}
			}
			
			if(_hasParamNames)
			{
				for (i = 0; i < param_count; ++i) 
				{
					_paramNameArr[i] = SWFUtil.readU30(byte);
				}
			}
			
			include "../reference/IReferenced_Fragment_1.as";
		}

		private function onParseComplete(event:ABCFileEvent):void
		{
			creatRefrenceRelationship();
		}
		
		override public function toXML(name:String = null):SWFXML
		{
			if(!name) name = "MethodInfo";
			var xml:SWFXML = new SWFXML(name);
			xml.setAttribute("returnType", "mn(" + _returnType + ")");
			xml.setAttribute("name", _name + "(" + $abcFile.getStringByIndex(_name) + ")");
			xml.setAttribute("needArguments", _needArguments);
			xml.setAttribute("needActivation", _needActivation);
			xml.setAttribute("needRest", _needRest);
			xml.setAttribute("hasOptional", _hasOptional);
			xml.setAttribute("setDXNS", _setDXNS);
			xml.setAttribute("hasParamNames", _hasParamNames);
			var params:SWFXML = new SWFXML("params");
			xml.appendChild(params);
			var length:int = _paramNameArr.length;
			for (var i:int = 0; i < length; ++i) 
			{
				if(_hasParamNames)
				{
					params.appendChild("<param paramType=\"" + _paramTypesArr[i] + "\" paramName=\"" + _paramNameArr[i] + "\"/>");
				}else{
					params.appendChild("<param paramType=\"" + _paramTypesArr[i] + "\"/>");
				}
			}
			
			if(_hasOptional)
			{
				var optionals:SWFXML = new SWFXML("optional");
				xml.appendChild(optionals);
				length = _optionArr.length;
				for (i = 0; i < length; ++i) 
				{
					optionals.appendChild(_optionArr[i].toXML());
				}
			}
			
			return xml;
		}
		
		
		override public function encode():ByteArray
		{
			var byte:ByteArray = new ByteArray;
			byte.endian = Endian.LITTLE_ENDIAN;
			var paramLenght:int = _paramTypesArr.length;
			SWFUtil.writeU30(byte, paramLenght);//write param_count
			SWFUtil.writeU30(byte, _returnType);//write return_type
			//write param_type
			for (var i:int = 0; i < paramLenght; ++i) 
			{
				SWFUtil.writeU30(byte, _paramTypesArr[i]);
			}
			SWFUtil.writeU30(byte, _name);// write name
			var flag:int = 0;
			if(_needArguments) 				flag |= 0x01;
			if(_needActivation) 			flag |= 0x02;
			if(_needRest) 					flag |= 0x04;
			if(_hasOptional)			flag |= 0x08;
			if(_setDXNS)					flag |= 0x40;
			if(_hasParamNames)				flag |= 0x80;
			byte.writeByte(flag);
			
			var length:int;
			//write option_info
			if(_hasOptional)
			{
				length = _optionArr.length;
				SWFUtil.writeU30(byte, length);//write option_count
				//write option_detail
				for (i = 0; i < length; ++i) 
				{
					byte.writeBytes(_optionArr[i].encode());
				}
			}
			
			//write paramName
			if(_hasParamNames)
			{
				for (i = 0; i < length; ++i) 
				{
					SWFUtil.writeU30(byte, _paramNameArr[i]);
				}
			}
			
			return byte;
		}
		
		public function toString():String
		{
			var str:String = "[ MethodInfo name:" + $abcFile.getStringByIndex(_name) + "parames:";
			var length:int = _paramTypesArr.length;
			for (var i:int = 0; i < length; ++i) 
			{
				str += $abcFile.getMultinameByIndex(_paramTypesArr[i]) + " ";
			}
			str += "  returnType" + $abcFile.getMultinameByIndex(_returnType) + "]";
			return str;
		}
		
		public function creatRefrenceRelationship():void
		{
			$abcFile.getMultinameByIndex(_returnType).addReference(this, "returnType");
			$abcFile.getStringByIndex(_name).addReference(this, "name");
			var length:int = _paramTypesArr.length;
			for (var i:int = 0; i < length; ++i) 
			{
				$abcFile.getMultinameByIndex(i).addReference(this, "paramTypesArr", i);
			}
			
			if(_hasParamNames)
			{
				length = _paramNameArr.length;
				for (i = 0; i < length; ++i) 
				{
					$abcFile.getStringByIndex(i).addReference(this, "paramNameArr", i);
				}
			}
		}
		
	}
}