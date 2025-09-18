-------------------------------------------------------------------------------  
-- Author       Sudha Vemulapalli
-- Created      '2021-05-12 00:00:00.000'  
-- Purpose      To Save prent child relation of the Widget  
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------  
--EXEC [dbo].[USP_UpsertChildWidget] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@WidgetName='Test',@IsArchived = 0,  
--@RoleIds = '<ArrayOfGuid><guid>860484f4-2e1f-4a0a-bd36-3509611ea6e3</guid><guid>5a678ce2-f096-4da0-bacb-fcfdca40f573</guid></ArrayOfGuid>'  
-------------------------------------------------------------------------------  
Create PROCEDURE  [dbo].[USP_UpsertChildWidget]
(  
   @WidgetId UNIQUEIDENTIFIER = NULL,  
   @parentId UNIQUEIDENTIFIER  = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)  
AS  
BEGIN  
 SET NOCOUNT ON  
 BEGIN TRY  
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
     IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL  
  
   
	DECLARE @Currentdate DATETIME = GETDATE()  
	DECLARE @DashboardRelationId UNIQUEIDENTIFIER
    SET @DashboardRelationId = NEWID()  
  INSERT INTO DashboardRelation 
	([DashboardRelationId],[ParentDashboardId],[ChildDashboardId],[CreatedDateTime],[CreatedByUserId], [UpdatedDateTime],[UpdatedByUserId])
  VALUES 
	( @DashboardRelationId,@WidgetId,@parentId,@Currentdate, @OperationsPerformedBy, @Currentdate, @OperationsPerformedBy)

END TRY  
 BEGIN CATCH  
  
  THROW  
  
 END CATCH  
  
END 
