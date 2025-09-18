-------------------------------------------------------------------------------
-- Author       Mahesh Musuku
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update ContractType
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertContractType]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@ContractTypeName = 'Test',@IsArchived = 0								  
---------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertContractType]
(
   @ContractTypeId UNIQUEIDENTIFIER = NULL,
   @ContractTypeName NVARCHAR(50) = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER ,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	    IF(@ContractTypeName = '') SET @ContractTypeName = NULL
		IF(@IsArchived = 1 AND @ContractTypeId IS NOT NULL)
        BEGIN
		 DECLARE @IsEligibleToArchive NVARCHAR(1000) = '1'
	     IF(EXISTS(SELECT Id FROM [Contract] WHERE ContractTypeId = @ContractTypeId))
	     BEGIN
	     SET @IsEligibleToArchive = 'ThisContractTypeUsedInContractPleaseDeleteTheDependenciesAndTryAgain'
	     END
		 IF(@IsEligibleToArchive <> '1')
		 BEGIN
		     RAISERROR (@isEligibleToArchive,11, 1)
		 END
	    END
	    IF(@ContractTypeName IS NULL)
		BEGIN
		    RAISERROR(50011,16, 2, 'ContractTypeName')
		END
		ELSE
		BEGIN
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		DECLARE @ContractTypeIdCount INT = (SELECT COUNT(1) FROM ContractType  WHERE Id = @ContractTypeId)
		DECLARE @ContractTypeNameCount INT = (SELECT COUNT(1) FROM ContractType WHERE ContractTypeName = @ContractTypeName AND CompanyId = @CompanyId AND (@ContractTypeId IS NULL OR Id <> @ContractTypeId))
	    IF(@ContractTypeIdCount = 0 AND @ContractTypeId IS NOT NULL)
        BEGIN
            RAISERROR(50002,16, 2,'ContractTypeName')
        END
        ELSE IF(@ContractTypeNameCount > 0)
        BEGIN
          RAISERROR(50001,16,1,'ContractType')
         END
         ELSE
		  BEGIN
		             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			         IF (@HavePermission = '1')
			         BEGIN
			         	DECLARE @IsLatest BIT = (CASE WHEN @ContractTypeId IS NULL
			         	                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
			                                                                    FROM [ContractType] WHERE Id = @ContractTypeId) = @TimeStamp
			         													THEN 1 ELSE 0 END END)
			             IF(@IsLatest = 1)
			         	 BEGIN
			                 DECLARE @Currentdate DATETIME = GETDATE()

		IF(@ContractTypeId IS NULL)
		BEGIN

			SET @ContractTypeId = NEWID()
             INSERT INTO [dbo].[ContractType](
                         [Id],
						 [CompanyId],
						 [ContractTypeName],
						 [InActiveDateTime],
						 [CreatedDateTime],
						 [CreatedByUserId]					
						 )
                  SELECT @ContractTypeId,
						 @CompanyId,
						 @ContractTypeName,
						 CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 @Currentdate,
						 @OperationsPerformedBy	
			             
		END
		ELSE
		BEGIN
				
				UPDATE [dbo].[ContractType]
					SET  [CompanyId]			= 		   @CompanyId,
						 [ContractTypeName]		= 		   @ContractTypeName,
						 [InActiveDateTime]		= 		   CASE WHEN @IsArchived =1 THEN @Currentdate ELSE NULL END,
						 [UpdatedDateTime]		= 		   @Currentdate,
						 [UpdatedByUserId]		= 		   @OperationsPerformedBy	
					WHERE Id = @ContractTypeId

		END
			 SELECT Id FROM [dbo].[ContractType] WHERE Id = @ContractTypeId
			           END
			           ELSE
			           	RAISERROR (50008,11, 1)
			         END
			         ELSE
			         BEGIN
			         		RAISERROR (@HavePermission,11, 1)
			         END
           END
		END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END
GO
