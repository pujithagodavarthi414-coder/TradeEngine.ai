-------------------------------------------------------------------------------------------------------
-- Author       Aswani k
-- Created      '2019-05-06 00:00:00.000'
-- Purpose      To Save or Update SoftLabel
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------------------------------
--EXEC [dbo].[USP_UpsertSoftLabel]  @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@SoftLabelName = '3SWT8E85H4',
--@BranchId = '63053486-89D4-47B6-AB2A-934A9F238812' ,@IsArchived = 0
---------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertSoftLabel]
(
   @SoftLabelId UNIQUEIDENTIFIER = NULL,
   @SoftLabelName NVARCHAR(800) = NULL, 
   @SoftLabelKeyType NVARCHAR(500) = NULL,
   @SoftLabelValue NVARCHAR(500) = NULL,
   @BranchId UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @IsArchived BIT = NULL,
   @TimeStamp TIMESTAMP = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@BranchId = '00000000-0000-0000-0000-000000000000') SET @BranchId = NULL

		IF(@SoftlabelName = '') SET @SoftlabelName = NULL

	    IF(@SoftlabelName IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'SoftLabelName')

		END
		ELSE IF(@BranchId IS NULL)
		BEGIN

		  RAISERROR(50011,16, 2,'Branch')

		END
		ELSE
		BEGIN

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
        
        DECLARE @SoftLabelCount INT = (SELECT COUNT(1) FROM SoftLabel  WHERE Id = @SoftLabelId)
        
		DECLARE @SoftLabelNameCount INT = (SELECT COUNT(1) FROM SoftLabel WHERE SoftLabelName = @SoftLabelName
		                                   AND CompanyId = @CompanyId AND (@SoftLabelId IS NULL OR Id <> @SoftLabelId) ) 

        IF(@SoftLabelCount = 0 AND @SoftLabelId IS NOT NULL)
        BEGIN

            RAISERROR(50002,16, 2,'SoftLabel')

        END
		ELSE IF(@SoftLabelNameCount > 0)
        BEGIN
        
          RAISERROR(50001,16,1,'SoftLabel')
           
        END
        ELSE
        BEGIN
       
             DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
            
             IF (@HavePermission = '1')
             BEGIN
                        
                  DECLARE @IsLatest BIT = (CASE WHEN @SoftLabelId  IS NULL 
                                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                                                                FROM [SoftLabel] WHERE Id = @SoftLabelId) = @TimeStamp
                                                                        THEN 1 ELSE 0 END END)
                     
                  IF(@IsLatest = 1)
                  BEGIN
                     
                       DECLARE @Currentdate DATETIME = GETDATE()
                       
                    IF(@SoftLabelId IS NULL)
					BEGIN

					SET @SoftLabelId = NEWID()
                       INSERT INTO [dbo].[SoftLabel](
                                   [Id],
                                   [CompanyId],
                                   [SoftLabelName],
								   [SoftLabelKeyType],
								   [SoftLabelValue],
                                   [BranchId],
                                   [InActiveDateTime],
                                   [CreatedDateTime],
                                   [CreatedByUserId])                 
                            SELECT @SoftLabelId,
                                   @CompanyId,
                                   @SoftLabelName,
								   @SoftLabelKeyType,
								   @SoftLabelValue,
                                   @BranchId,
                                   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   @Currentdate,
                                   @OperationsPerformedBy        
                            
							END
							ELSE
							BEGIN

							UPDATE [dbo].[SoftLabel]
								SET [CompanyId]			   = 	   @CompanyId,
                                   [SoftLabelName]		   = 	   @SoftLabelName,
								   [SoftLabelKeyType]	   = 	   @SoftLabelKeyType,
								   [SoftLabelValue]		   = 	   @SoftLabelValue,
                                   [BranchId]			   = 	   @BranchId,
                                   [InActiveDateTime]	   = 	   CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                                   [UpdatedDateTime]	   = 	   @Currentdate,
                                   [UpdatedByUserId]	   = 	   @OperationsPerformedBy        
								   WHERE Id = @SoftLabelId

							END
                         SELECT Id Id FROM [dbo].[SoftLabel] WHERE Id = @SoftLabelId
                                   
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