CREATE PROCEDURE [dbo].[USP_UpsertAuditCategory]
(
 @AuditCategoryId UNIQUEIDENTIFIER = NULL,
 @AuditCategoryName NVARCHAR(800) = NULL,
 @IsArchived BIT = 0,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @ParentAuditCategoryId UNIQUEIDENTIFIER = NULL,
 @AuditComplianceId UNIQUEIDENTIFIER = NULL,
 @AuditCategoryDescription NVARCHAR(800) = NULL
 )
AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@AuditCategoryId = '00000000-0000-0000-0000-000000000000') SET @AuditCategoryId = NULL

		 IF(@AuditCategoryName = '') SET @AuditCategoryName = NULL
		
		 IF(@IsArchived IS NULL)SET @IsArchived = 0

		 DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditComplianceId)

		 DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))
		  
		IF (@HavePermission = '1')
		BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 DECLARE @AuditCategoryNameCount INT = (SELECT COUNT(1) FROM AuditCategory WHERE AuditCategoryName = @AuditCategoryName AND AuditComplianceId = @AuditComplianceId AND ((@ParentAuditCategoryId IS NULL AND ParentAuditCategoryId IS NULL) OR ParentAuditCategoryId = @ParentAuditCategoryId) AND InActiveDateTime IS NULL AND (@AuditCategoryId IS NULL OR Id <> @AuditCategoryId))

		 DECLARE @IsLatest BIT = (CASE WHEN @AuditCategoryId  IS NULL 
                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      FROM [AuditCategory] WHERE Id = @AuditCategoryId ) = @TimeStamp
                                                         THEN 1 ELSE 0 END END)
          IF(@AuditCategoryName IS NULL)
		  BEGIN
			    
				RAISERROR(50011,16, 2, 'CategoryName')
			
		  END
		  ELSE IF(@IsArchived = 0 AND @AuditCategoryNameCount >0)
		  BEGIN

				RAISERROR(50001,16, 2, 'CategoryName')

		  END
		  ELSE IF(@AuditComplianceId IS NULL)
		  BEGIN

				RAISERROR(50011,16,2,'AuditCompliance')

		  END
         ELSE IF(@IsLatest = 1)
         BEGIN

		 DECLARE @Currentdate DATETIME = GETDATE()
		 DECLARE @OldValue NVARCHAR(MAX) = NULL
		 DECLARE @NewValue NVARCHAR(MAX) = NULL

		 IF(@AuditCategoryId IS NULL)
		 BEGIN
		 DECLARE @MaxOrderId INT = 0
		 DECLARE @MaxOrderCategoryId INT = 0
		 IF(@ParentAuditCategoryId IS NULL)
		 BEGIN
		  IF EXISTS(SELECT COUNT(1) FROM AuditCategory WHERE AuditComplianceId = @AuditComplianceId AND InActiveDateTime IS NULL AND [Order] IS NULL AND ParentAuditCategoryId IS NULL)
		  BEGIN
			;With PUpdateData  As
			(
			SELECT Id,
			ROW_NUMBER() OVER (ORDER BY CreatedDateTime) AS [Order]
			FROM AuditCategory WHERE AuditComplianceId = @AuditComplianceId AND InActiveDateTime IS NULL AND ParentAuditCategoryId IS NULL
			)
			UPDATE AuditCategory SET [Order] = P.[Order]
			FROM AuditCategory AC
			INNER JOIN PUpdateData P ON AC.Id = P.Id
		  END
		  SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM AuditCategory WHERE AuditComplianceId = @AuditComplianceId AND InActiveDateTime IS NULL AND ParentAuditCategoryId IS NULL
		  END
		 ELSE
		 BEGIN
		 IF EXISTS(SELECT COUNT(1) FROM AuditCategory WHERE ParentAuditCategoryId = @ParentAuditCategoryId AND InActiveDateTime IS NULL AND [Order] IS NULL)
		  BEGIN
			;With UpdateData  As
			(
			SELECT Id,
			ROW_NUMBER() OVER (ORDER BY CreatedDateTime) AS [Order]
			FROM AuditCategory WHERE ParentAuditCategoryId = @ParentAuditCategoryId AND InActiveDateTime IS NULL
			)
			UPDATE AuditCategory SET [Order] = P.[Order]
			FROM AuditCategory AC
			INNER JOIN UpdateData P ON AC.Id = P.Id
		  END
			SELECT @MaxOrderId = ISNULL(Max([Order]),0) FROM AuditCategory WHERE ParentAuditCategoryId = @ParentAuditCategoryId AND InActiveDateTime IS NULL
		 END		  

		 SET @MaxOrderCategoryId = @MaxOrderId + 1

		 SET @AuditCategoryId = NEWID()

		 INSERT INTO [dbo].[AuditCategory](
                     [Id],
                     [ParentAuditCategoryId],
                     [AuditCategoryName],
                     [InActiveDateTime],
                     [CreatedDateTime],
                     [CreatedByUserId],
					 [AuditComplianceId],
					 [AuditCategoryDescription],
					 [Order]
					 )
         SELECT @AuditCategoryId,
                @ParentAuditCategoryId,
                @AuditCategoryName,
                CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                @Currentdate,
                @OperationsPerformedBy,
				@AuditComplianceId,
				@AuditCategoryDescription,
				@MaxOrderCategoryId

		 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
				SELECT NEWID(), @AuditComplianceId, NULL, NULL, NULL, @AuditCategoryName, 'AuditCategoryCreated', GETDATE(), @OperationsPerformedBy

		END
		ELSE
		BEGIN

						DECLARE @OldCategoryName NVARCHAR(800) = NULL
                        DECLARE @OldCategoryDescription NVARCHAR(800) = NULL

						SELECT @OldCategoryName = AuditCategoryName,
							   @OldCategoryDescription = AuditCategoryDescription
							   FROM AuditCategory WHERE Id = @AuditCategoryId

						IF(@IsArchived = 1)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [Field], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @AuditCategoryName, NULL, AC.AuditCategoryName, 'AuditCategoryArchived', GETDATE(), @OperationsPerformedBy
								FROM AuditCategory AC WHERE AC.Id IN (SELECT Id FROM Ufn_GetMultiSubCategories(@AuditCategoryId))

						UPDATE AuditCategory SET UpdatedDateTime  = IIF(@IsArchived = 1,@Currentdate,NULL),
						                            UpdatedByUserId  = IIF(@IsArchived = 1,@OperationsPerformedBy,NULL),
													InActiveDateTime = IIF(@IsArchived = 1,@Currentdate,NULL)
													WHERE Id IN (SELECT Id FROM Ufn_GetMultiSubCategories(@AuditCategoryId))
													 AND Id <> @AuditCategoryId AND @IsArchived = 1 AND InActiveDateTime IS NULL
						UPDATE [AuditCategory]
					     SET [ParentAuditCategoryId] = @ParentAuditCategoryId,
						     [AuditCategoryName] = @AuditCategoryName,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							 [UpdatedDateTime] = @Currentdate,
							 [AuditComplianceId] = @AuditComplianceId,
							 [UpdatedByUserId] = @OperationsPerformedBy,
							 [AuditCategoryDescription] = @AuditCategoryDescription
							 WHERE Id = @AuditCategoryId

						IF(ISNULL(@OldCategoryName,'') <> @AuditCategoryName)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [Field], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @AuditCategoryName, @OldCategoryName, @AuditCategoryName, 'AuditCategoryNameUpdated', GETDATE(), @OperationsPerformedBy

						IF(ISNULL(@OldCategoryDescription,'') <> @AuditCategoryDescription)
						 INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [Field], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditComplianceId, NULL, NULL, @AuditCategoryName, @OldCategoryDescription, @AuditCategoryDescription, 'AuditCategoryDescriptionUpdated', GETDATE(), @OperationsPerformedBy

				         END
		
		SELECT Id  FROM [dbo].[AuditCategory] WHERE Id = @AuditCategoryId

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