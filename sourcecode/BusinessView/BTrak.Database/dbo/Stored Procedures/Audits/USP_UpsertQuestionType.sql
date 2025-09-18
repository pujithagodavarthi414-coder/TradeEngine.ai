CREATE PROCEDURE [dbo].[USP_UpsertQuestionType]
(
 @QuestionTypeId UNIQUEIDENTIFIER = NULL,
 @QuestionTypeName NVARCHAR(800) = NULL,
 @IsArchived BIT = NULL,
 @TimeStamp TIMESTAMP = NULL,
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @MasterQuestionTypeId UNIQUEIDENTIFIER = NULL,
 @IsFromMasterQuestionType BIT = NULL,
 @QuestionTypeOptions XML = NULL
)
AS
 BEGIN
         SET NOCOUNT ON
         BEGIN TRY
		 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

		 IF(@OperationsperformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		 IF(@QuestionTypeId = '00000000-0000-0000-0000-000000000000') SET @QuestionTypeId = NULL

		 IF(@QuestionTypeName = '') SET @QuestionTypeName = NULL

		 DECLARE @HavePermission NVARCHAR(250)  = '1'--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		  
		  IF (@HavePermission = '1')
		  BEGIN

		 DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		 IF(@QuestionTypeName IS NULL AND @IsFromMasterQuestionType = 1)
		 BEGIN
			DECLARE @Name NVARCHAR(800) = (Select MasterQuestionTypeName FROM MasterQuestionType WHERE Id = @MasterQuestionTypeId AND InActiveDateTime IS NULL)

			DECLARE @NameCount INT = (SELECT COUNT(1) FROM QuestionTypes WHERE QuestionTypeName like '%' + @name + '%' AND InActiveDateTime IS NULL)

			SET @QuestionTypeName = CONCAT(@Name,'-',@NameCount + 1,'-',(select NEWID()))
		 END

		 CREATE TABLE #QuestionTypeOptions(
									      QuestionTypeId UNIQUEIDENTIFIER,
									      QuestionTypeOptionId UNIQUEIDENTIFIER,
										  QuestionTypeOptionName NVARCHAR(250),
										  QuestionTypeOptionScore FLOAT,
										  QuestionTypeOptionOrder INT
		                                 )
        INSERT INTO #QuestionTypeOptions(QuestionTypeOptionId,QuestionTypeOptionName,QuestionTypeOptionScore,QuestionTypeOptionOrder)
		SELECT 	x.y.value('(QuestionTypeOptionId/text())[1]','uniqueidentifier'),
				x.y.value('(QuestionTypeOptionName)[1]','nvarchar(250)'),
				x.y.value('(QuestionTypeOptionScore)[1]','float'),
				x.y.value('(QuestionTypeOptionOrder)[1]','int')
				FROM @QuestionTypeOptions.nodes('/GenericListOfQuestionTypeOptionsModel/ListItems/QuestionTypeOptionsModel') AS x(y)

		 DECLARE @IsLatest BIT = (CASE WHEN @QuestionTypeId  IS NULL 
                                      THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
                                      FROM [QuestionTypes] WHERE Id = @QuestionTypeId ) = @TimeStamp
                                                         THEN 1 ELSE 0 END END)

         DECLARE @Count INT = (SELECT MAX(Cnt) FROM (SELECT QuestionTypeOptionName,COUNT(1) AS Cnt FROM #QuestionTypeOptions GROUP BY QuestionTypeOptionName) T)

		 DECLARE @QuestionTypeNameCount INT = (SELECT COUNT(1) FROM QuestionTypes WHERE QuestionTypeName = @QuestionTypeName AND (Id <> @QuestionTypeId OR @QuestionTypeId IS NULL) AND CompanyId = @CompanyId)
		  
          IF(@MasterQuestionTypeId IS NULL)
		  BEGIN

				RAISERROR(50011,16,1,'MasterQuestionType')

		  END
		  ELSE IF(@QuestionTypeName IS NULL)
		  BEGIN
			    
				RAISERROR(50011,16, 2, 'QuestionTypeName')
			
		  END
		  ELSE IF(ISNULL(@Count,0) > 1)
		  BEGIN

			   RAISERROR('DuplicateOptionsAreNotAllowed',11,1)

		  END
		  ELSE IF(@QuestionTypeNameCount > 0)
		  BEGIN
		  
			   RAISERROR(50001,16, 2, 'QuestionTypeName')
		  
		  END
         IF(@IsLatest = 1)
         BEGIN

		 DECLARE @Currentdate DATETIME = GETDATE()

		 IF(@QuestionTypeId IS NULL)
		 BEGIN

		 SET @QuestionTypeId = NEWID()

		 INSERT INTO [dbo].[QuestionTypes](
                     [Id],
					 [MasterQuestionTypeId],
                     [CompanyId],
                     [QuestionTypeName],
					 [IsFromMasterQuestionType],
                     [InActiveDateTime],
                     [CreatedDateTime],
                     [CreatedByUserId]
					 )
              SELECT @QuestionTypeId,
			         @MasterQuestionTypeId,
                     @CompanyId,
                     @QuestionTypeName,
					 @IsFromMasterQuestionType,
                     CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
                     @Currentdate,
                     @OperationsPerformedBy

		END
		ELSE
		BEGIN
						UPDATE [QuestionTypes]
					     SET [CompanyId] = @CompanyId,
						     [MasterQuestionTypeId] = @MasterQuestionTypeId,
						     [QuestionTypeName] = @QuestionTypeName,
							 [InActiveDateTime] = CASE WHEN @IsArchived = 1 THEN @Currentdate ELSE NULL END,
							 [UpdatedDateTime] = @Currentdate,
							 [UpdatedByUserId] = @OperationsPerformedBy
							 WHERE Id = @QuestionTypeId
		END

		UPDATE QuestionTypeOptions SET InactiveDateTime = GETDATE(),UpdatedDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy WHERE QuestionTypeId = @QuestionTypeId AND Id NOT IN (SELECT ISNULL(QuestionTypeOptionId,NEWID()) FROM #QuestionTypeOptions) AND InactiveDateTime IS NULL
		
		UPDATE AuditAnswers SET InactiveDateTime = GETDATE(),UpdatedDateTime = GETDATE(),UpdatedByUserId = @OperationsPerformedBy 
		WHERE QuestionTypeOptionId IN (SELECT Id FROM QuestionTypeOptions 
		                                WHERE Id NOT IN (SELECT ISNULL(QuestionTypeOptionId,NEWID()) 
									                     FROM #QuestionTypeOptions) 
										AND QuestionTypeId = @QuestionTypeId)
		
		UPDATE QuestionTypeOptions SET InactiveDateTime = NULL
                                      ,QuestionTypeOptionName = QT.QuestionTypeOptionName
									  ,QuestionTypeOptionOrder = QT.QuestionTypeOptionOrder
									  ,QuestionTypeOptionScore = QT.QuestionTypeOptionScore
                                      ,UpdatedDateTime = GETDATE()
                                      ,UpdatedByUserId = @OperationsPerformedBy
									   FROM QuestionTypeOptions QTO 
								       JOIN #QuestionTypeOptions QT ON QT.QuestionTypeOptionId = QTO.Id
                                           AND QTO.QuestionTypeId = @QuestionTypeId 

		INSERT INTO QuestionTypeOptions(
										Id,
										QuestionTypeId,
										QuestionTypeOptionName,
										QuestionTypeOptionOrder,
										QuestionTypeOptionScore,
										CreatedByUserId,
										CreatedDateTime
		                               )

							     SELECT NEWID(),
										@QuestionTypeId,
								        QuestionTypeOptionName,
										QuestionTypeOptionOrder,
										QuestionTypeOptionScore,
										@OperationsPerformedBy,
										GETDATE()
								        FROM #QuestionTypeOptions WHERE QuestionTypeOptionId IS NULL

		SELECT Id  FROM [dbo].[QuestionTypes] WHERE Id = @QuestionTypeId

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