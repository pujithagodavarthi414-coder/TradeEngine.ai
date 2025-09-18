-------------------------------------------------------------------------------
-- Author       Pujitha Godavarthi 
-- Created      '2019-01-21 00:00:00.000'
-- Purpose      To Save or Update the ProjectFeature
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------- 
--EXEC [dbo].[USP_UpsertProjectFeature] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@ProjectId = '6F709278-861C-4E07-856C-E2BD8F8892A6'
--------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertProjectFeature]
(
  @FeatureId  UNIQUEIDENTIFIER = NULL,
  @FeatureName  NVARCHAR(250) = NULL,
  @FeatureResponsiblePersonId UNIQUEIDENTIFIER = NULL,
  @ProjectId UNIQUEIDENTIFIER = NULL,
  @IsDelete  BIT = NULL,
  @IsArchived BIT = NULL,
  @TimeStamp TIMESTAMP = NULL,
  @TimeZone NVARCHAR(250) = NULL,
  @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
     SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
	 
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                    
        IF (@HavePermission = '1')
        BEGIN
		
		IF (@FeatureResponsiblePersonId = '00000000-0000-0000-0000-000000000000') SET @FeatureResponsiblePersonId = NULL;

		DECLARE @FeatureIdCount INT = (SELECT COUNT(1) FROM ProjectFeature WHERE Id = @FeatureId)

		DECLARE @ProjectFeatureResponsibleId UNIQUEIDENTIFIER = NULL

		DECLARE @ProjectFeatureNameCount INT = (SELECT COUNT(1) FROM [ProjectFeature] WHERE ProjectFeatureName = @FeatureName 
		AND ProjectId = @ProjectId AND (Id <> @FeatureId OR @FeatureId IS NULL))

		IF(@FeatureIdCount = 0 AND @FeatureId IS NOT NULL)
		BEGIN
			RAISERROR(50002,16, 1,'ProjectComponent')
		END
		
		ELSE IF(@ProjectFeatureNameCount > 0)
		BEGIN

			RAISERROR(50001,16,1,'ProjectComponent')

		END

		ELSE
		BEGIN

		DECLARE @IsLatest BIT = (CASE WHEN @Featureid IS NULL THEN 1 ELSE 
		                         CASE WHEN (SELECT [TimeStamp] FROM ProjectFeature WHERE Id = @FeatureId) = @TimeStamp THEN 1 ELSE 0 END END)

		IF(@IsLatest = 1)
		BEGIN

    	DECLARE @Currentdate DATETIME = GETDATE()

		IF (@FeatureId IS NULL)
		BEGIN
			
			SET @FeatureId = NEWID()
			      INSERT INTO [dbo].[ProjectFeature](
				                                     [Id],
				                        			 [ProjectFeatureName],
				                        			 [ProjectId],
				                        			 [IsDelete],
				                        			 [CreatedDateTime],
				                        			 [CreatedByUserId],
				                        			 [InActiveDateTime]
				                        			)
				                              SELECT @FeatureId,
				                        			 @FeatureName,
				                        			 @ProjectId,
				                        			 @IsDelete,
				                        			 @Currentdate,
				                        			 @OperationsPerformedBy,
				                        			 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

					EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = '', @NewValue = @FeatureName, @FieldName = 'ComponentAdded',
		                                          @Description = 'ComponentAdded', @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @FeatureId

		END
		ELSE
		BEGIN

			EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
			                                     @FeatureId = @FeatureId,
												 @FeatureName = @FeatureName,
												 @ComponentIsArchived = @IsArchived,
                                                 @OperationsPerformedBy = @OperationsPerformedBy

			UPDATE [dbo].[ProjectFeature]
				SET [ProjectFeatureName]   =  		 @FeatureName,
				    [ProjectId]			   =  		 @ProjectId,
				    [IsDelete]			   =  		 @IsDelete,
				    [UpdatedDateTime]	   =  		 @Currentdate,
				    [UpdatedByUserId]	   =  		 @OperationsPerformedBy,
				    [InActiveDateTime]	   =  		 CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
				WHERE Id = @FeatureId

		END

			SELECT @ProjectFeatureResponsibleId = Id FROM [dbo].[ProjectFeatureResponsiblePerson] WHERE ProjectFeatureId = @FeatureId

		IF(@ProjectFeatureResponsibleId IS NULL)
		BEGIN
		 
            INSERT INTO [dbo].[ProjectFeatureResponsiblePerson](
                                                                [Id],
                                                                [ProjectFeatureId],
                                                                [UserId],
                                                                [IsDelete],
                                                                [CreatedDateTime],
                                                                [CreatedByUserId],
                                                                [InActiveDateTime]
                                                               )
                                                        SELECT  NEWID(),
                                                                @FeatureId,
                                                                @FeatureResponsiblePersonId,
                                                                @IsDelete,
                                                                @Currentdate,
                                                                @OperationsPerformedBy,
                                                                CASE WHEN @IsDelete = 1 THEN @Currentdate ELSE NULL END

			END
			ELSE
			BEGIN

				EXEC [USP_InsertProjectAuditHistory] @ProjectId = @ProjectId,
				                                     @FeatureId = @FeatureId,
				                                     @FeatureResponsiblePersonId = @FeatureResponsiblePersonId,
													 @ComponentResponsiblePersonIsDeleted = @IsDelete,
                                                     @OperationsPerformedBy = @OperationsPerformedBy

				UPDATE [dbo].[ProjectFeatureResponsiblePerson]
					SET [ProjectFeatureId]	  =  	   @FeatureId,
                        [UserId]			  =  	   @FeatureResponsiblePersonId,
                        [IsDelete]			  =  	   @IsDelete,
                        [UpdatedDateTime]	  =  	   @Currentdate,
                        [UpdatedByUserId]	  =  	   @OperationsPerformedBy,
                        [InActiveDateTime]	  =  	   CASE WHEN @IsDelete = 1 THEN @Currentdate ELSE NULL END
					WHERE Id = @ProjectFeatureResponsibleId

			END
       
            SELECT Id FROM [dbo].[ProjectFeature] WHERE Id = @FeatureId
        END
        ELSE
           
           RAISERROR(50008,11,1)
        END
      END
      ELSE
      BEGIN
              
        RAISERROR (@HavePermission,11, 1)
                 
      END
    END TRY  
    BEGIN CATCH 
        
        THROW
    END CATCH
END