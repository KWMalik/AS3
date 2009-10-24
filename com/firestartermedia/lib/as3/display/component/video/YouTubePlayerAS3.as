/**
 * @author			Ahmed Nuaman (http://www.ahmednuaman.com)
 * @langversion		3
 * 
 * This work is licenced under the Creative Commons Attribution-Share Alike 2.0 UK: England & Wales License. 
 * To view a copy of this licence, visit http://creativecommons.org/licenses/by-sa/2.0/uk/ or send a letter 
 * to Creative Commons, 171 Second Street, Suite 300, San Francisco, California 94105, USA.
*/
package com.firestartermedia.lib.as3.display.component.video
{
	import com.firestartermedia.lib.as3.events.YouTubePlayerEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	public class YouTubePlayerAS3 extends Sprite
	{
		public var playerHeight:Number							= 300;
		public var playerWidth:Number							= 400;
		
		private var isLoaded:Boolean							= false;
		private var requestURL:String							= 'http://www.youtube.com/apiplayer?version=3';
		
		private var player:Object;
		private var videoId:String;
		
		public function YouTubePlayerAS3()
		{
			Security.allowDomain( '*' );
			Security.allowDomain( 'www.youtube.com' );  
			Security.allowDomain( 'youtube.com' );  
			Security.allowDomain( 's.ytimg.com' );  
			Security.allowDomain( 'i.ytimg.com' );
		}
		
		public function play(videoId:String):void
		{
			this.videoId = videoId;
			
			if ( !isLoaded )
			{
				loadPlayer();
			}
			else
			{
				playVideo();
			}	
		}
		
		private function loadPlayer():void
		{
			var request:URLRequest 	= new URLRequest( requestURL );
			var loader:Loader 		= new Loader();
			
			loader.contentLoaderInfo.addEventListener( Event.INIT, handleLoaderInit );
			
			loader.load( request );	
		}
		
		private function handleLoaderInit(e:Event):void
		{
			var player:Object = e.target.content;
			
			player.addEventListener( 'onReady', 				handlePlayerReady );
			player.addEventListener( 'onStateChange', 			handlePlayerStateChange );
			player.addEventListener( 'onPlaybackQualityChange', handlePlayerQualityChange );
			player.addEventListener( 'onError', 				handlePlayerError );
			
			addChild( player as DisplayObject );
		}
		
		private function handlePlayerReady(e:Event):void
		{
			player 					= e.target;
			
			isLoaded 				= true;
			
			dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.READY ) );
			
			player.setSize( playerWidth, playerHeight );
			
			playVideo();
		}
		
		private function handlePlayerStateChange(e:Object):void
		{
			var state:Number 		= player.getPlayerState();
			
			switch ( state )
			{
				case 0:
				dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.ENDED ) );
				
				break;
				
				case 1:
				dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.PLAYING ) );
				
				break;
				
				case 2:
				dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.PAUSED ) );
				
				break;
				
				case 3:
				dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.BUFFERING ) );
				
				break;
				
				case 4:
				// hmmm?
									
				break;
				
				case 5:
				dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.QUEUED ) );
				
				break;
				
				default:
				dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.NOT_STARTED ) );
				
				break;
			}
		}
		
		private function handlePlayerQualityChange(e:Object):void
		{
			dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.QUALITY_CHANGED, getPlaybackQuality() ) ); 
		}
		
		private function handlePlayerError(e:Object):void
		{
			dispatchEvent( new YouTubePlayerEvent( YouTubePlayerEvent.ERROR, e ) );
		}
		
		private function playVideo():void
		{
			if ( isLoaded )
			{	
				player.loadVideoById( videoId );
			}
		}
		
		public function stop():void
		{
			if ( isLoaded )
			{
				player.stopVideo();
			}
		}
		
		public function pause():void
		{
			if ( isLoaded )
			{
				player.pauseVideo();
			}
		}
		
		public function resume():void
		{
			if ( isLoaded )
			{
				player.resumeVideo();
			}
		}
		
		public function getCurrentTime():Number
		{
			return player.getCurrentTime();
		}
		
		public function getDuration():Number
		{
			return player.getDuration();
		}
		
		public function getVideoUrl():String
		{
			return player.getVideoUrl();
		}
		
		public function getPlaybackQuality():String
		{
			return player.getPlaybackQuality();
		}
		
		public function setPlaybackQuality(suggestedQuality:String):void
		{
			player.setPlaybackQuality( suggestedQuality );
		}
		
		override public function set height(value:Number):void
		{
			playerHeight 			= value;
			
			if ( isLoaded )
			{
				player.resize( playerWidth, playerHeight );
			}
		}
		
		override public function set width(value:Number):void
		{
			playerWidth 			= value;
			
			if ( isLoaded )
			{
				player.resize( playerWidth, playerHeight );
			}
		}
	}
}