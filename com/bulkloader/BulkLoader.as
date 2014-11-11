package com.bulkloader {
	import flash.events.EventDispatcher;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.net.URLLoader;
	
	/*
	 * @author: Massaki Archambault
	 */
	
	public class BulkLoader extends EventDispatcher{
		
		protected var _itemList:Array = new Array;
		
		public function BulkLoader() {
		}
		
		//Ajoute un élément dans la liste de chargement
		public function addItem(url:String, format:String = URLLoaderDataFormat.BINARY):uint
		{
			var item:exLoader = new exLoader;
			item.url = url;
			item.dataFormat = format;
			item.parent = this;
			
			item.addEventListener(Event.COMPLETE, loaded);
			
			var id:uint = _itemList.push(item) - 1;
			item.id = id;
			return id;
		}
		
		//Récupère un loader selon l'id
		public function getItemAt(id:uint):*
		{
			return _itemList[id].data;
		}
		
		//Charge tout
		public function loadAll():void
		{
			var itemLoaded:Boolean = false;
			
			for each(var item:* in _itemList)
			{
				if(!item.isComplete)
				{
					item.load(new URLRequest(item.url));
					itemLoaded = true;
				}
			}
			
			if(!itemLoaded || !_itemList.length) //Si tout a déjà été chargé ou il n'y a rien à charger
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//Vérifie si tout a été chargé
		public function loadComplete():Boolean
		{
			for each(var item:* in _itemList)
				if(!item.isComplete)
					return false;
			return true;
		}
		
		//Traitement
		protected function loaded(e:Event):void
		{
			var item:exLoader = e.currentTarget as exLoader;
			
			item.removeEventListener(Event.COMPLETE, loaded);
			item.isComplete = true;
			
			if(item.parent.loadComplete()) //Si tout a été chargé
				dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function get itemList():Array { return _itemList; }
	}
	
}
import flash.net.URLLoader;
import com.bulkloader.BulkLoader;

class exLoader extends URLLoader{
	public var url:String;
	public var parent:BulkLoader;
	public var id:uint;
	public var isComplete:Boolean = false;
}