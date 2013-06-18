Ext.define('CarTracker.view.car.edit.tab.Color', {
	extend: 'Ext.panel.Panel',
	alias: 'widget.car.edit.tab.color',
	layout: 'form',
	initComponent: function() {
		var me = this;
		Ext.applyIf(me, {
			items: [
				{
					xtype: 'itemselectorfield',
					name: 'Colors',
		            anchor: '100%',
		            imagePath: '../ux/images/',
		            store: {
		            	type: 'option.color'
		            },
		            displayField: 'LongName',
		            valueField: 'ColorID',
		            allowBlank: false,
		            msgTarget: 'side',
		            fromTitle: 'Available Colors',
		            toTitle: 'Selected Colors',
		            buttons: [ 'add', 'remove' ],
		            delimiter: undefined
				}
			]
		});
		me.callParent( arguments );
	}
});