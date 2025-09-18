-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-01-28 00:00:00.000'
-- Purpose      To Get The ButtonTypes By Applyind Different Filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
  
--EXEC [dbo].[USP_GetButtonTypeById] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ButtonTypeId='795671B4-BD69-426A-B47D-6A65B94801A6'

CREATE  PROCEDURE  [dbo].[USP_GetButtonTypeById]                                                                             
(
  @ButtonTypeId  UNIQUEIDENTIFIER ,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)                                                
AS                
BEGIN
	SET NOCOUNT ON	                             
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		IF (@ButtonTypeId =  '00000000-0000-0000-0000-000000000000') SET @ButtonTypeId=NULL

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
	    
		SELECT Id AS ButtonTypeId 
		       ,ButtonTypeName
			   ,IsStart
			   ,IsFinish
			   ,IsLunchStart
			   ,IsLunchEnd
			   ,IsBreakIn
			   ,BreakOut
        FROM ButtonType WITH (NOLOCK)
	    WHERE Id = @ButtontypeId AND CompanyId = @CompanyId

	END TRY  
	BEGIN CATCH 	

		THROW

	END CATCH
END


