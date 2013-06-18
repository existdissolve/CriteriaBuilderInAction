/**
* Handler for Cars
*/
component extends="CarTracker.handlers.Base" {
	property name="CarService" inject;
	property name="MakeService" inject;
	property name="ModelService" inject;
	property name="CategoryService" inject;
	property name="StatusService" inject;
	property name="ColorService" inject;
	property name="FeatureService" inject;
	property name="StaffService" inject;
	
	// OPTIONAL HANDLER PROPERTIES
	this.prehandler_only 	= "";
	this.prehandler_except 	= "";
	this.posthandler_only 	= "";
	this.posthandler_except = "";
	this.aroundHandler_only = "";
	this.aroundHandler_except = "";		
	// REST Allowed HTTP Methods Ex: this.allowedMethods = {delete='POST,DELETE',index='GET'}
	this.allowedMethods = {
		list="GET",
		view="GET",
		create="POST",
		update="PUT",
		remove="DELETE"
	};
	
	/**
	IMPLICIT FUNCTIONS: Uncomment to use
	function preHandler(event,action,eventArguments){
		var rc = event.getCollection();
	}
	function postHandler(event,action,eventArguments){
		var rc = event.getCollection();
	}
	function aroundHandler(event,targetAction,eventArguments){
		var rc = event.getCollection();
		// executed targeted action
		arguments.targetAction(event);
	}
	function onMissingAction(event,missingAction,eventArguments){
		var rc = event.getCollection();
	}
	function onError(event,faultAction,exception,eventArguments){
		var rc = event.getCollection();
	}
	*/
		
	function list( required Any event, required Struct rc, required Struct prc ){
		// retrieve Cars based on search criteria
		var car = CarService.collect( argumentCollection=arguments.rc );
		prc.jsonData = {
			"count" = car.count,
			"data"  = EntityUtils.parseEntity( entity=car.data, simpleValues=true, excludeList="Status,Make,Model,Category,Color,Features,SalesPeople" )
		};
	}	

	function view( required Any event, required Struct rc, required Struct prc ){
		// get car based on passed id
		var car = CarService.get( arguments.rc.CarID );
		prc.jsonData = EntityUtils.parseEntity( entity=car, simpleValues=true );
	}	

	function create( required Any event, required Struct rc, required Struct prc ){
		// populate car
		var car = CarService.populate( memento=arguments.rc, exclude="Status,Make,Model,Category,Color,Features,SalesPeople" );
		if( structKeyExists( rc, "Status" ) ) {
			car.setStatus( StatusService.get( rc.Status ) );
		}
		if( structKeyExists( rc, "Make" ) ) {
			car.setMake( MakeService.get( rc.Make ) );
		}
		if( structKeyExists( rc, "Model" ) ) {
			car.setModel( ModelService.get( rc.Model ) );
		}
		if( structKeyExists( rc, "Category" ) ) {
			car.setCategory( CategoryService.get( rc.Category ) );
		}
		if( structKeyExists( rc, "Color" ) ) {
			car.setColor( ColorService.get( rc.Color ) );
		}
		if( structKeyExists( rc, "Features" ) ) {
			for( var feature in rc.Features ) {
				car.addFeature( FeatureService.get( feature ) );
			}
		}
		if( structKeyExists( rc, "SalesPeople" ) ) {
			for( var staff in rc.SalesPeople ) {
				car.addSalesPerson( StaffService.get( staff ) );
			}
		}
		// validate model
		prc.validationResults = validateModel( car );
		// if there are errors, handle it
		if( prc.validationResults.hasErrors() ) {
			prc.jsonData = {
				"data" = errorsToArray( prc.validationResults.getErrors() ),
				"success" = false,
				"message" = "Please correct the following errors",
				"type" = "validation"
			};
			return;
		}
		// save the car
		CarService.save( car );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=car, simpleValues=true ),
			"success" = true,
			"message" = "The Car was created successfully!",
			"type" = "success"
		};
	}	

	function update( required Any event, required Struct rc, required Struct prc ){
		// populate car
		var car = CarService.populate( memento=arguments.rc, exclude="Status,Make,Model,Category,Color,Features,SalesPeople" );
		if( structKeyExists( rc, "Status" ) ) {
			car.setStatus( StatusService.get( rc.Status ) );
		}
		if( structKeyExists( rc, "Make" ) ) {
			car.setMake( MakeService.get( rc.Make ) );
		}
		if( structKeyExists( rc, "Model" ) ) {
			car.setModel( ModelService.get( rc.Model ) );
		}
		if( structKeyExists( rc, "Category" ) ) {
			car.setCategory( CategoryService.get( rc.Category ) );
		}
		if( structKeyExists( rc, "Color" ) ) {
			car.setColor( ColorService.get( rc.Color ) );
		}
		if( structKeyExists( rc, "Features" ) ) {
			car.getFeatures().clear();
			for( var feature in rc.Features ) {
				car.addFeature( FeatureService.get( feature ) );
			}
		}
		if( structKeyExists( rc, "SalesPeople" ) ) {
			car.getSalesPeople().clear();
			for( var staff in rc.SalesPeople ) {
				car.addSalesPerson( StaffService.get( staff ) );
			}
		}
		// validate model
		prc.validationResults = validateModel( car );
		// if there are errors, handle it
		if( prc.validationResults.hasErrors() ) {
			prc.jsonData = {
				"data" = errorsToArray( prc.validationResults.getErrors() ),
				"success" = false,
				"message" = "Please correct the following errors",
				"type" = "validation"
			};
			return;
		}
		// save the car
		CarService.save( car );
		prc.jsonData = {
			"data"  = EntityUtils.parseEntity( entity=car, simpleValues=true ),
			"success" = true,
			"message" = "The Car was updated successfully!",
			"type" = "success"
		};
	}	

	function remove( required Any event, required Struct rc, required Struct prc ){
		// delete by incoming id
		CarService.deleteByID( arguments.rc.CarID );
		prc.jsonData = {
			"data"  = "",
			"success" = true,
			"message" = "The Car was deleted successfully!",
			"type" = "success"
		};
	}
}
