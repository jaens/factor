/* :folding=explicit:collapseFolds=1: */

/*
 * $Id$
 *
 * Copyright (C) 2003, 2004 Slava Pestov.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 *    this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * DEVELOPERS AND CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package factor;

import factor.compiler.FactorCompiler;
import factor.math.*;
import java.io.UnsupportedEncodingException;
import java.lang.reflect.*;
import java.math.BigInteger;

/**
 * A few methods for converting between Java types at runtime.
 * Note that the compiler incorporates calls to some of these methods in
 * generated bytecode.
 */
public class FactorJava
{
	public static final Class[] EMPTY_ARRAY = new Class[0];

	//{{{ getSanitizedName() method
	public static String getSanitizedName(String name)
	{
		StringBuffer sanitizedName = new StringBuffer();
		for(int i = 0; i < name.length(); i++)
		{
			char ch = name.charAt(i);
			if(!Character.isJavaIdentifierStart(ch))
				sanitizedName.append("_");
			else
				sanitizedName.append(ch);
		}
		return sanitizedName.toString();
	} //}}}

	//{{{ classNameToClassList() method
	public static Class[] classNameToClassList(Cons classes)
		throws Exception
	{
		if(classes == null)
			return EMPTY_ARRAY;

		Class[] _classes = new Class[classes.length()];
		int i = 0;
		while(classes != null)
		{
			Object car = classes.car;
			if(car instanceof Cons)
			{
				Cons classSpec = (Cons)car;
				if(classSpec.cdr != null)
				{
					throw new FactorRuntimeException(
						"Bad class spec: " + car);
				}
				Class clazz = (Class)classSpec.car(Class.class);
				if(clazz.isPrimitive())
				{
					_classes[i] = getClass("["
						+ javaClassToVMClass(clazz));
				}
				else
				{
					_classes[i] = getClass("[L"
						+ clazz.getName() + ";");
				}
			}
			else
				_classes[i] = (Class)classes.car(Class.class);

			i++;
			classes = classes.next();
		}

		return _classes;
	} //}}}

	//{{{ toNumber() method
	public static Number toNumber(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number)
			return (Number)arg;
		else if(arg instanceof Character)
			return new Integer((int)((Character)arg).charValue());
		else if(arg instanceof String)
		{
			Number num = NumberParser.parseNumber((String)arg,10);
			if(num != null)
				return num;
		}

		throw new FactorDomainException(arg,Number.class);
	} //}}}

	//{{{ toString() method
	public static String toString(Object arg)
	{
		if(arg == null)
			return null;
		else if(arg instanceof String)
			return (String)arg;
		else
			return String.valueOf(arg);
	} //}}}

	//{{{ toCharSequence() method
	public static CharSequence toCharSequence(Object arg)
	{
		if(arg instanceof CharSequence)
			return ((CharSequence)arg);
		else
			return toString(arg);
	} //}}}
	
	//{{{ toBoolean() method
	public static boolean toBoolean(Object arg)
	{
		if(Boolean.FALSE.equals(arg) || arg == null)
			return false;
		else
			return true;
	} //}}}

	//{{{ toByte() method
	public static byte toByte(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number && !(arg instanceof Complex))
			return ((Number)arg).byteValue();
		else if(arg instanceof Character)
			return (byte)(((Character)arg).charValue());
		else if(arg instanceof String)
			return Byte.parseByte((String)arg);
		else
			throw new FactorDomainException(arg,byte.class);
	} //}}}

	//{{{ toShort() method
	public static short toShort(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number && !(arg instanceof Complex))
			return ((Number)arg).shortValue();
		else if(arg instanceof Character)
			return (short)(((Character)arg).charValue());
		else if(arg instanceof String)
			return Short.parseShort((String)arg);
		else
			throw new FactorDomainException(arg,short.class);
	} //}}}

	//{{{ toChar() method
	public static char toChar(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Character)
			return ((Character)arg).charValue();
		else if(arg == null)
			return '\0';
		else if(arg instanceof String)
		{
			String s = (String)arg;
			if(s.length() != 1)
				throw new FactorDomainException(arg,char.class);
			return s.charAt(0);
		}
		else if(arg instanceof Number)
		{
			return (char)((Number)arg).intValue();
		}
		else
			throw new FactorDomainException(arg,char.class);
	} //}}}

	//{{{ toInt() method
	public static int toInt(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number && !(arg instanceof Complex))
			return ((Number)arg).intValue();
		else if(arg instanceof Character)
			return (int)(((Character)arg).charValue());
		else if(arg instanceof String)
			return Integer.parseInt((String)arg);
		else
			throw new FactorDomainException(arg,int.class);
	} //}}}

	//{{{ toLong() method
	public static long toLong(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number && !(arg instanceof Complex))
			return ((Number)arg).longValue();
		else if(arg instanceof Character)
			return (long)(((Character)arg).charValue());
		else if(arg instanceof String)
			return Long.parseLong((String)arg);
		else
			throw new FactorDomainException(arg,long.class);
	} //}}}

	//{{{ toFloat() method
	public static float toFloat(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number && !(arg instanceof Complex))
			return ((Number)arg).floatValue();
		else if(arg instanceof Character)
			return (float)(((Character)arg).charValue());
		else if(arg instanceof String)
			return Float.parseFloat((String)arg);
		else
			throw new FactorDomainException(arg,float.class);
	} //}}}

	//{{{ toDouble() method
	public static double toDouble(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof Number && !(arg instanceof Complex))
			return ((Number)arg).doubleValue();
		else if(arg instanceof Character)
			return (double)(((Character)arg).charValue());
		else if(arg instanceof String)
			return Double.parseDouble((String)arg);
		else
			throw new FactorDomainException(arg,double.class);
	} //}}}

	//{{{ toBigInteger() method
	public static BigInteger toBigInteger(Object arg)
		throws FactorDomainException
	{
		if(arg instanceof BigInteger)
			return (BigInteger)arg;
		else if(arg instanceof Character)
		{
			return BigInteger.valueOf(
				(long)(((Character)arg).charValue()));
		}
		else if(arg instanceof Number)
			return BigInteger.valueOf(((Number)arg).longValue());
		else
			throw new FactorDomainException(arg,BigInteger.class);
	} //}}}

	//{{{ toClass() method
	public static Class toClass(Object arg)
		throws Exception
	{
		if(arg instanceof Class)
			return (Class)arg;
		else
		{
			return getClass((String)
				convertToJavaType(arg,String.class));
		}
	} //}}}

	//{{{ toNamespace() method
	public static FactorNamespace toNamespace(Object obj) throws Exception
	{
		if(obj instanceof FactorNamespace)
			return (FactorNamespace)obj;
		else if(obj instanceof FactorObject)
		{
			FactorNamespace ns = ((FactorObject)obj)
				.getNamespace();
			if(ns == null)
				throw new FactorRuntimeException(
					obj + " has a null"
					+ " namespace");
			return ns;
		}
		else
		{
			throw new FactorDomainException(obj,
				FactorObject.class);
		}
	} //}}}

	//{{{ toBooleanArray() method
	public static boolean[] toBooleanArray(Object arg)
		throws FactorDomainException
	{
		if(arg == null)
			return new boolean[0];
		else if(arg instanceof Cons)
			arg = toArray(arg,Object[].class);

		try
		{
			boolean[] returnValue = new boolean[
				Array.getLength(arg)];
			for(int i = 0; i < returnValue.length; i++)
			{
				returnValue[i] = toBoolean(
					Array.get(arg,i));
			}
			return returnValue;
		}
		catch(IllegalArgumentException e)
		{
			throw new FactorDomainException(arg,boolean[].class);
		}
	} //}}}

	//{{{ toByteArray() method
	public static byte[] toByteArray(Object arg)
		throws FactorDomainException
	{
		if(arg == null)
			return new byte[0];
		else if(arg instanceof Cons)
			arg = toArray(arg,Object[].class);
		if(arg.getClass().isArray())
		{
			try
			{
				byte[] returnValue = new byte[
					Array.getLength(arg)];
				for(int i = 0; i < returnValue.length; i++)
				{
					returnValue[i] = toByte(
						Array.get(arg,i));
				}
				return returnValue;
			}
			catch(IllegalArgumentException e)
			{
				throw new FactorDomainException(arg,byte[].class);
			}
		}
		else
		{
			try
			{
				return String.valueOf(arg).getBytes("UTF8");
			}
			catch(UnsupportedEncodingException e)
			{
				throw new RuntimeException(e);
			}
		}
	} //}}}

	//{{{ toArray() method
	public static Object[] toArray(Object arg)
		throws FactorDomainException
	{
		return toArray(arg,Object[].class);
	} //}}}

	//{{{ toArray() method
	public static Object[] toArray(Object arg, Class clas)
		throws FactorDomainException
	{
		if(arg == null)
		{
			return (Object[])Array.newInstance(
				clas.getComponentType(),0);
		}
		else if(arg instanceof Cons)
		{
			Cons list = (Cons)arg;
			Object[] array = (Object[])
				Array.newInstance(
				clas.getComponentType(),
				list.length());
			list.toArray(array);
			return array;
		}
		else if(arg.getClass().isArray())
		{
			if(arg.getClass() == clas)
				return (Object[])arg;
			else
			{
				Object[] _arg = (Object[])arg;
				Object[] array = (Object[])
					Array.newInstance(
					clas.getComponentType(),
					_arg.length);
				System.arraycopy(arg,0,array,0,
					_arg.length);
				return array;
			}
		}
		else
			throw new FactorDomainException(arg,Object[].class);
	} //}}}

	//{{{ convertToJavaType() method
	public static Object convertToJavaType(Object arg, Class clas)
		throws Exception
	{
		if(clas.isPrimitive())
			clas = getBoxingType(clas);

		if(clas == Object.class)
			return arg;
		else if(clas == Number.class)
		{
			return toNumber(arg);
		}
		else if(clas == String.class)
		{
			return toString(arg);
		}
		else if(clas == CharSequence.class)
		{
			return toCharSequence(arg);
		}
		else if(clas == Boolean.class)
		{
			if(arg instanceof Boolean)
				return arg;
			else
				return Boolean.valueOf(toBoolean(arg));
		}
		else if(clas == Byte.class)
		{
			if(arg instanceof Byte)
				return arg;
			else
				return new Byte(toByte(arg));
		}
		else if(clas == Character.class)
		{
			if(arg instanceof Character)
				return arg;
			return new Character(toChar(arg));
		}
		else if(clas == Integer.class)
		{
			if(arg instanceof Integer)
				return arg;
			else
				return new Integer(toInt(arg));
		}
		else if(clas == Long.class)
		{
			if(arg instanceof Long)
				return arg;
			else
				return new Long(toLong(arg));
		}
		else if(clas == Float.class)
		{
			if(arg instanceof Float)
				return arg;
			else
				return new Float(toFloat(arg));
		}
		else if(clas == Double.class)
		{
			if(arg instanceof Double)
				return arg;
			else
				return new Double(toDouble(arg));
		}
		else if(clas == BigInteger.class)
		{
			if(arg instanceof BigInteger)
				return arg;
			else
				return toBigInteger(arg);
		}
		else if(clas == FactorNamespace.class)
		{
			if(arg instanceof FactorNamespace)
				return arg;
			else
				return toNamespace(arg);
		}
		else if(clas == Class.class)
		{
			return toClass(arg);
		}
		else if(clas.isArray())
		{
			Class comp = clas.getComponentType();
			if(!comp.isPrimitive())
				return toArray(arg,clas);
			else if(comp == boolean.class)
				return toBooleanArray(arg);
			else if(comp == byte.class)
				return toByteArray(arg);
		}

		if(arg != null && !clas.isInstance(arg))
			throw new FactorDomainException(arg,clas);
		else
			return arg;
	} //}}}

	//{{{ fromBoolean() method
	public static Object fromBoolean(boolean b)
	{
		return (b ? Boolean.TRUE : null);
	} //}}}

	//{{{ convertFromJavaType() method
	public static Object convertFromJavaType(Object arg)
	{
		if(Boolean.FALSE.equals(arg))
			return null;
		else
			return arg;
	} //}}}

	//{{{ javaClassToVMClass() method
	public static String javaClassToVMClass(Class clazz)
	{
		String name = clazz.getName();

		if(clazz.isArray())
			return clazz.getName().replace('.','/');
		else if(name.equals("boolean"))
			return "Z";
		else if(name.equals("byte"))
			return "B";
		else if(name.equals("char"))
			return "C";
		else if(name.equals("double"))
			return "D";
		else if(name.equals("float"))
			return "F";
		else if(name.equals("int"))
			return "I";
		else if(name.equals("long"))
			return "J";
		else if(name.equals("short"))
			return "S";
		else if(name.equals("void"))
			return "V";
		else
			return "L" + clazz.getName().replace('.','/') + ";";
	} //}}}

	//{{{ getBoxingType() method
	public static Class getBoxingType(Class clazz)
	{
		if(clazz == Boolean.TYPE)
			return Boolean.class;
		else if(clazz == Byte.TYPE)
			return Byte.class;
		else if(clazz == Character.TYPE)
			return Character.class;
		else if(clazz == Double.TYPE)
			return Double.class;
		else if(clazz == Float.TYPE)
			return Float.class;
		else if(clazz == Integer.TYPE)
			return Integer.class;
		else if(clazz == Long.TYPE)
			return Long.class;
		else if(clazz == Short.TYPE)
			return Short.class;
		else
			return null;
	} //}}}

	//{{{ javaSignatureToVMSignature() method
	public static String javaSignatureToVMSignature(Class[] args,
		Class returnType)
	{
		StringBuffer buf = new StringBuffer("(");
		for(int i = 0; i < args.length; i++)
		{
			buf.append(javaClassToVMClass(args[i]));
		}
		buf.append(")");
		buf.append(javaClassToVMClass(returnType));
		return buf.toString();
	} //}}}

	//{{{ getClass() method
	public static Class getClass(String name) throws ClassNotFoundException
	{
		if(name.equals("boolean"))
			return Boolean.TYPE;
		else if(name.equals("byte"))
			return Byte.TYPE;
		else if(name.equals("char"))
			return Character.TYPE;
		else if(name.equals("double"))
			return Double.TYPE;
		else if(name.equals("float"))
			return Float.TYPE;
		else if(name.equals("int"))
			return Integer.TYPE;
		else if(name.equals("long"))
			return Long.TYPE;
		else if(name.equals("short"))
			return Short.TYPE;
		else
			return Class.forName(name);
	} //}}}

	//{{{ unwrapException() method
	public static Throwable unwrapException(Throwable e)
	{
		if(e instanceof InvocationTargetException)
		{
			return unwrapException(
				((InvocationTargetException)e)
				.getTargetException());
		}
		else if(e.getCause() != null)
			return unwrapException(e.getCause());
		else
			return e;
	} //}}}
}
