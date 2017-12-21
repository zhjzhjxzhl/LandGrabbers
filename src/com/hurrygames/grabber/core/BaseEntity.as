package com.hurrygames.grabber.core
{
	import com.hurrygames.grabber.managers.LoopController;
	
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Project : LandGrabbers
	 * BaseEntity
	 * @author 赵俊 <zhaojun@crop.the9.com>  
	 * $Id:$
	 * @version 1.0
	 */
	public class BaseEntity implements IEntity
	{
		private var _components:Dictionary = new Dictionary();
		
		private var _model:IModel;
		
		public function BaseEntity()
		{
			
		}
		
		public function addComponent(component:IComponent,name:String):void
		{
			if(_components == null)
			{
				trace(flash.utils.getQualifiedClassName(this) + "已经销毁了，不要再添加组件");
				return;
			}
			component.init(this);
			if(component is IModel)
			{
				_model = component as IModel;
				return;
			}
			if(_components[name] != null)
			{
				removeComponentByName(name);
			}
			
			_components[name] = component;
			component.Entity = this;
			
			if(component is ILogic)
			{
				LoopController.instance.addLogicLoop((component as ILogic).onTick);
			}
			if(component is IRender)
			{
				LoopController.instance.addRenderLoop((component as IRender).render);
			}
		}
		
		
		public function removeComponentByName(name:String,deep:Boolean = true):void
		{
			var component:IComponent = _components[name];
			
			if(component)
			{
				component.destory(deep);
				
				if(component is IModel)
				{
					_model = null;
				}
				
				delete _components[name];
				component.Entity = null;
				
				if(component is ILogic)
				{
					LoopController.instance.removeLogicLoop((component as ILogic).onTick);
				}
				if(component is IRender)
				{
					LoopController.instance.removeRenderLoop((component as IRender).render);
				}
			}
		}
		
		public function getComponentByName(name:String):IComponent
		{
			return _components[name];
		}
		
		/**
		 * 获取一类组件。 
		 * @param type
		 * @return 
		 * 
		 */		
		public function getComponentsByTyep(type:Class):Vector.<IComponent>
		{
			var components:Vector.<IComponent> = new Vector.<IComponent>();
			for(var name:String in _components)
			{
				if(_components[name] is type)
				{
					components.push(_components[name]);
				}
			}
			return components;
		}
		
		public function get Model():IModel
		{
			return _model;
		}
		
		/**
		 * 清理所有的components。同时清理相关的资源。 
		 * 
		 */		
		public function destory(deep:Boolean = true):void
		{
			for(var name:String in _components)
			{
				removeComponentByName(name,deep);
			}
			_model.destory(deep);
			_model = null;
			deep && (_components = null);
		}
		
		
	}
} 
