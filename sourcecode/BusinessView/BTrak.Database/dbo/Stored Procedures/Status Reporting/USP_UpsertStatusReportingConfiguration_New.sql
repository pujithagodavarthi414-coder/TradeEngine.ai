-------------------------------------------------------------------------------
-- Author       Ranadheer Rana Velaga
-- Modified      '2019-06-21 00:00:00.000'
-- Purpose      To save or update status reportingconfigurations 
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved  
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_UpsertStatusReportingConfiguration_New] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
 --@GenericFormId = '4588A593-20D3-4AF9-8851-3513BE8CD2DF',@ConfigurationName = 'Ongole',
 --@UserIds = 'F6AE7214-2B1B-46FD-A775-9FF356CD6E0F,127133F1-4427-4149-9DD6-B02E0E036972',@StatusReportingOptionIds = 
 --'DFE38C65-CD5E-48C1-91D1-68A902BE2A30,3B422297-5A20-4F49-A0C6-F3277C233F76',@StatusReportingConfigurationId = 'E6844348-7C69-4DCF-8932-23C412727153',@TimeStamp = 0x00000000000025EA
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertStatusReportingConfiguration_New]
(
    @StatusReportingConfigurationId  UNIQUEIDENTIFIER = NULL,
    @ConfigurationName NVARCHAR(250),
    @GenericFormId  UNIQUEIDENTIFIER = NULL,
    @UserIds NVARCHAR(MAX),
    @StatusReportingOptionIds NVARCHAR(MAX),
    @IsArchived BIT = NULL,
    @TimeStamp TIMESTAMP = NULL,
    @OperationsPerformedBy UNIQUEIDENTIFIER 
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	  DECLARE @HavePermission NVARCHAR(250) = (SELECt [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

	  IF (@HavePermission = '1')
	  BEGIN

      IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

      IF (@GenericFormId = '00000000-0000-0000-0000-000000000000') SET @GenericFormId = NULL

      IF (@ConfigurationName = '') SET @ConfigurationName = NULL

	   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

      IF(@GenericFormId IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'GenericForm')

      END

      ELSE IF(@ConfigurationName IS NULL)
      BEGIN
           
           RAISERROR(50011,16, 2, 'ConfigurationName')

      END

      ELSE 
      BEGIN

	    IF(@StatusReportingConfigurationId = '00000000-0000-0000-0000-000000000000') SET @StatusReportingConfigurationId = NULL
        
		DECLARE @StatusReportingConfigurationIdCount INT = (SELECT COUNT(1) FROM StatusReportingConfiguration_New WHERE Id = @StatusReportingConfigurationId)
        
		DECLARE @ConfigurationNameCount INT = (SELECT COUNT(1) FROM StatusReportingConfiguration_New  SRC
															INNER JOIN GenericForm GF ON GF.Id = SRC.GenericFormId
														    INNER JOIN Formtype FT ON FT.Id = GF.FormTypeId 
															           AND FT.CompanyId = @CompanyId
															WHERE ConfigurationName = @ConfigurationName AND 
															(@StatusReportingConfigurationId IS NULL OR (SRC.Id <> @StatusReportingConfigurationId)) AND SRC.InActiveDateTime IS NULL)
        
		IF(@StatusReportingConfigurationIdCount = 0 AND @StatusReportingConfigurationId IS NOT NULL)
        BEGIN
            
			RAISERROR(50002,16,1,'StatusReportingConfiguration')
        
		END
        
		ELSE IF(@ConfigurationNameCount > 0)
        BEGIN
            
			RAISERROR(50001,16,1,'StatusReportingConfiguration')
        
		END
        
		ELSE
        BEGIN
        
        DECLARE @IsLatest BIT = (CASE WHEN @StatusReportingConfigurationId IS NULL THEN 1 ELSE CASE WHEN (SELECT [TimeStamp] FROM StatusReportingConfiguration_New WHERE Id = @StatusReportingConfigurationId) = @TimeStamp THEN 1 ELSE 0 END END)
        
		IF(@IsLatest = 1)
        BEGIN
            
			DECLARE @Currentdate DATETIME = GETDATE()
				
				IF(@StatusReportingConfigurationId IS NULL)
				BEGIN
					
					SET @StatusReportingConfigurationId = NEWID()

					INSERT INTO [dbo].[StatusReportingConfiguration_New](
                                         [Id],
                                         [ConfigurationName],
                                         [GenericFormId],
                                         [AssignedByUserId],
                                         [AssignedDateTime],
                                         [CreatedByUserId],
                                         [CreatedDateTime],
                                         [InActiveDateTime]
                                        )
                                  SELECT @StatusReportingConfigurationId,
                                         @ConfigurationName,
                                         @GenericFormId,
                                         @OperationsPerformedBy,
                                         @Currentdate,
                                         @OperationsPerformedBy,
                                         @Currentdate,
                                         CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END

			END
			ELSE
			BEGIN
				
				UPDATE [dbo].[StatusReportingConfiguration_New]
				    SET [ConfigurationName] = @ConfigurationName
					    ,[GenericFormId] = @GenericFormId
						,[AssignedByUserId] = @OperationsPerformedBy
						,[AssignedDateTime] = @Currentdate
						,[UpdatedDateTime] = @Currentdate
						,[UpdatedByUserId]  =@OperationsPerformedBy
						,[InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END
					WHERE Id = @StatusReportingConfigurationId

			END

			IF(@IsArchived IS NULL OR @IsArchived = 0)
			BEGIN

			UPDATE StatusReportingConfigurationOption SET [InActiveDateTime] = @Currentdate WHERE StatusReportingConfigurationId = @StatusReportingConfigurationId
                  
				   INSERT INTO [dbo].[StatusReportingConfigurationOption](
                                                                          [Id],
                                                                          [StatusReportingConfigurationId],
                                                                          [StatusReportingOptionId],
                                                                          [CreatedByUserId],
                                                                          [CreatedDateTime]
                                                                          )
                                                                   SELECT NEWID(),
                                                                          @StatusReportingConfigurationId,
                                                                          Id,
                                                                          @OperationsPerformedBy,
                                                                          @Currentdate
                                                                   FROM [dbo].[UfnSplit](@StatusReportingOptionIds)
				  
				  UPDATE StatusReportingConfigurationUser SET [InActiveDateTime] = @Currentdate WHERE StatusReportingConfigurationId = @StatusReportingConfigurationId
                  
				  INSERT INTO [dbo].[StatusReportingConfigurationUser](
                                                                       [Id],
                                                                       [StatusReportingConfigurationId],
                                                                       [UserId],
                                                                       [CreatedByUserId],
                                                                       [CreatedDateTime]
                                                                      )
                                                                SELECT NEWID(),
                                                                       @StatusReportingConfigurationId,
                                                                       Id,
                                                                       @OperationsPerformedBy,
                                                                       @Currentdate
                                                               FROM [dbo].[UfnSplit](@UserIds)
            
			SELECT Id FROM [dbo].[StatusReportingConfiguration_New] where Id = @StatusReportingConfigurationId

			END
		 END
         ELSE
           
             RAISERROR(50008,11,1)
        END
      
	  END
   
    END
	ELSE
	     
		RAISERROR(@HavePermission,11,1)  

    END TRY
    
	BEGIN CATCH
         
		 THROW
   
    END CATCH
END