cc.Class {
    extends: cc.Component

    properties: {
        # foo:
        #   default: null      # The default value will be used only when the component attaching
        #                        to a node for the first time
        #   type: cc
        #   serializable: true # [optional], default is true
        #   visible: true      # [optional], default is true
        #   displayName: 'Foo' # [optional], default is property name
        #   readonly: false    # [optional], default is false
        display: cc.Sprite
    }

    start: ->
        @_isShow = false
        @tex = new cc.Texture2D()
        @_setGameType()

    _setGameType: ->
        wx.postMessage(
            {
                message: "gameType"
                gameType: "memory"
            }
        )

    onClick: ->
        cc.director.loadScene('memoryWelcome')

    onRefresh: ->
        wx.postMessage(
            {
                message: "Refresh"
            }
        )

    _updateSubDomainCanvas: ->
        return unless @tex?
        openDataContext = wx.getOpenDataContext()
        @tex.initWithElement(openDataContext.canvas)
        @tex.handleLoadedTexture()
        @display.spriteFrame = new cc.SpriteFrame(@tex)
    	
    update: (dt) ->
        @_updateSubDomainCanvas()
        # do your update here
}