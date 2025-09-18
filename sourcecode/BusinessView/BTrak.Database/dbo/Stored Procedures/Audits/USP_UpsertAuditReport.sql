CREATE PROCEDURE [dbo].[USP_UpsertAuditReport]
(
 @AuditReportId UNIQUEIDENTIFIER = NULL,
 @AuditReportName NVARCHAR(800) = NULL,
 @IsArchived BIT = 0,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @AuditConductId UNIQUEIDENTIFIER = NULL,
 @AuditReportDescription NVARCHAR(800) = NULL
 )
AS
 BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		 
		 IF(@AuditReportId = '00000000-0000-0000-0000-000000000000') SET @AuditReportId = NULL
		 
		 IF(@AuditConductId = '00000000-0000-0000-0000-000000000000') SET @AuditConductId = NULL

		 IF(@AuditReportName = '') SET @AuditReportName = NULL
		
		 IF(@IsArchived IS NULL)SET @IsArchived = 0

		 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditConduct WHERE Id = @AuditConductId)

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		  
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @IsLatest BIT = (CASE WHEN @AuditReportId  IS NULL 
                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      FROM [AuditReport] WHERE Id = @AuditReportId ) = @TimeStamp
                                                         THEN 1 ELSE 0 END END)
          
		  DECLARE @AuditReportNameCount INT = (SELECT COUNT(1) FROM AuditReport AR
		                                             INNER JOIN AuditCompliance AC ON AC.Id = AR.AuditConductId
		                                             WHERE AR.AuditReportName = @AuditReportName 
													 AND AR.CompanyId = @CompanyId
													 AND AR.InActiveDateTime IS NULL
													 AND AC.ProjectId = @ProjectId
		                                             AND (@AuditReportId IS NULL OR AR.Id <> @AuditReportId))

		  IF(@AuditReportName IS NULL)
		  BEGIN
			    
				RAISERROR(50011,16, 2, 'AuditReportName')
			
		  END
		  ELSE IF(@AuditReportNameCount > 0)
		  BEGIN

		    RAISERROR(50001,16, 2, 'AuditReportName')

		  END
		  ELSE IF(@AuditConductId IS NULL)
		  BEGIN

		    RAISERROR(50011,16,2,'AuditConduct')

		  END
         ELSE IF(@IsLatest = 1)
         BEGIN

		      DECLARE @Currentdate DATETIME = GETDATE()

		      IF(@AuditReportId IS NULL)
		      BEGIN
		           
		           SET @AuditReportId = NEWID()
		           
		           INSERT INTO [dbo].[AuditReport](
                               [Id],
                               [AuditReportName],
                               [InActiveDateTime],
                               [CreatedDateTime],
                               [CreatedByUserId],
		  	        		   [AuditConductId],
		  	        		   [AuditReportDescription],
							   [CompanyId]
		  	        		   )
                       SELECT  @AuditReportId,
                               @AuditReportName,
                               CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                               @Currentdate,
                               @OperationsPerformedBy,
		  	        	       @AuditConductId,
		  	        	       @AuditReportDescription,
							   @CompanyId

					   INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), (SELECT AuditComplianceId From AuditConduct WHERE Id = @AuditConductId GROUP BY AuditComplianceId), @AuditConductId, NULL, NULL, @AuditReportName, 'AuditReportCreated', GETDATE(), @OperationsPerformedBy		           

		           END
		           ELSE
		           BEGIN
						
						UPDATE [AuditReport]
					     SET [AuditReportName] = @AuditReportName,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							 [UpdatedDateTime] = @Currentdate,
							 [AuditConductId] = @AuditConductId,
							 [CompanyId] = @CompanyId,
							 [UpdatedByUserId] = @OperationsPerformedBy,
							 [AuditReportDescription] = @AuditReportDescription
						WHERE Id = @AuditReportId

						IF(@IsArchived = 1)
							INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), (SELECT AuditComplianceId From AuditConduct WHERE Id = @AuditConductId GROUP BY AuditComplianceId), @AuditConductId, NULL, NULL, @AuditReportName, 'AuditReportArchived', GETDATE(), @OperationsPerformedBy		           

		       END
		
		SELECT Id  FROM [dbo].[AuditReport] WHERE Id = @AuditReportId

		END
		ELSE
              
			  RAISERROR (50008,11, 1)

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
 GO