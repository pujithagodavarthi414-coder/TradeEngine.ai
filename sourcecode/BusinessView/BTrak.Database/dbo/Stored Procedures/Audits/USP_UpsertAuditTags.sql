CREATE PROCEDURE [dbo].[USP_UpsertAuditTags]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @AuditId UNIQUEIDENTIFIER = NULL,
 @ConductId UNIQUEIDENTIFIER = NULL,
 @TagsXml XML
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
        
        DECLARE @ProjectId UNIQUEIDENTIFIER = (SELECT ProjectId FROM AuditCompliance WHERE Id = @AuditId)

        IF(@ProjectId IS NULL) SET @ProjectId = (SELECT ProjectId FROM AuditConduct WHERE Id = @ConductId)

        DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveEntityFeatureAccess](@OperationsPerformedBy,@ProjectId,(SELECT OBJECT_NAME(@@PROCID))))

        IF(@HavePermission = '1')
        BEGIN
            
            CREATE TABLE #Tags(
                               Id UNIQUEIDENTIFIER,
                               AuditId UNIQUEIDENTIFIER,
                               AuditConductId UNIQUEIDENTIFIER,
                               TagId UNIQUEIDENTIFIER,
                               TagName NVARCHAR(MAX)
                              )

            INSERT INTO #Tags(
                              Id
                             ,AuditId
							 ,AuditConductId
                             ,TagId
                             ,TagName
                             )
                      SELECT NEWID()
                            ,@AuditId
							,@ConductId
                            ,x.y.value('(TagId)[1]','uniqueidentifier')
                            ,x.y.value('(TagName)[1]','nvarchar(MAX)')
                            FROM @TagsXml.nodes('/GenericListOfAuditTagsModel/ListItems/AuditTagsModel') AS x(y)

							  DECLARE @OldTagHistory NVARCHAR(MAX) = NULL
							  DECLARE @TagHistory NVARCHAR(MAX) = NULL

		IF(@ConductId IS NULL)
		BEGIN

           SET @OldTagHistory  = STUFF(( SELECT  ',' + TagName FROM AuditTags WHERE AuditId = @AuditId AND AuditConductId IS NULL AND InActiveDateTime IS NULL  ORDER BY TagName FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
           
           UPDATE AuditTags SET UpdatedByUserId = @OperationsPerformedBy
                               ,UpdatedDateTime = GETDATE()
                               ,InActiveDateTime = GETDATE()
                                FROM AuditTags AG
                                LEFT JOIN #Tags T ON T.AuditId = AG.AuditId AND T.TagId = AG.TagId AND AG.InactiveDateTime IS NULL 
                                WHERE T.Id IS NULL AND AG.AuditId = @AuditId AND AG.AuditConductId IS NULL

           UPDATE AuditTags SET UpdatedByUserId = @OperationsPerformedBy
                               ,UpdatedDateTime = GETDATE()
                               ,InActiveDateTime = NULL
                                FROM AuditTags AG
                                JOIN #Tags T ON T.AuditId = AG.AuditId AND T.TagId = AG.TagId AND AG.InactiveDateTime IS NOT NULL AND AG.AuditConductId IS NULL

          INSERT INTO AuditTags(
                                Id,
                                AuditId,
                                TagId,
                                TagName,
                                CreatedByUserId,
                                CreatedDateTime
                               )
                         SELECT T.Id,
                                T.AuditId,
                                T.TagId,
                                T.TagName,
                                @OperationsPerformedBy,
                                GETDATE()
                                FROM #Tags T
                                LEFT JOIN AuditTags AG ON T.AuditId = AG.AuditId AND T.TagId = AG.TagId AND AG.InactiveDateTime IS NULL AND AG.AuditConductId IS NULL
                                WHERE AG.Id IS NULL
    
                
                SET @TagHistory = STUFF(( SELECT  ',' + TagName FROM #Tags ORDER BY TagName FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
                
                IF(ISNULL(@OldTagHistory,'') <> ISNULL(@TagHistory,''))
                BEGIN

                   INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @AuditId, NULL, NULL, @OldTagHistory, @TagHistory, 'AuditTagsUpdated', GETDATE(), @OperationsPerformedBy 

                END

       --     IF(@TagsXml IS NULL)
       --         INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							--SELECT NEWID(), @AuditId, NULL, NULL, NULL, NULL, 'AuditTagsUpdated', GETDATE(), @OperationsPerformedBy

          SELECT AG.AuditId FROM AuditTags AG JOIN #Tags T ON T.AuditId = AG.AuditId AND AG.AuditConductId IS NULL GROUP BY AG.AuditId

		   END
		   ELSE
		   BEGIN

              SET @OldTagHistory  = STUFF(( SELECT  ',' + TagName FROM AuditTags WHERE AuditConductId = @ConductId AND InActiveDateTime IS NULL  ORDER BY TagName FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
           
           UPDATE AuditTags SET UpdatedByUserId = @OperationsPerformedBy
                               ,UpdatedDateTime = GETDATE()
                               ,InActiveDateTime = GETDATE()
                                FROM AuditTags AG
                                LEFT JOIN #Tags T ON T.AuditConductId = AG.AuditConductId AND T.TagId = AG.TagId AND AG.InactiveDateTime IS NULL
                                WHERE T.Id IS NULL AND AG.AuditConductId = @ConductId

           UPDATE AuditTags SET UpdatedByUserId = @OperationsPerformedBy
                               ,UpdatedDateTime = GETDATE()
                               ,InActiveDateTime = NULL
                                FROM AuditTags AG
                                JOIN #Tags T ON T.AuditConductId = AG.AuditConductId AND T.TagId = AG.TagId AND AG.InactiveDateTime IS NOT NULL

          INSERT INTO AuditTags(
                                Id,
                                AuditId,
								AuditConductId,
                                TagId,
                                TagName,
                                CreatedByUserId,
                                CreatedDateTime
                               )
                         SELECT T.Id,
                                NULL,
								@ConductId,
                                T.TagId,
                                T.TagName,
                                @OperationsPerformedBy,
                                GETDATE()
                                FROM #Tags T
                                LEFT JOIN AuditTags AG ON T.AuditConductId = AG.AuditConductId AND T.TagId = AG.TagId AND AG.InactiveDateTime IS NULL 
                                WHERE AG.Id IS NULL
    
               
                SET @TagHistory = STUFF(( SELECT  ',' + TagName FROM #Tags ORDER BY TagName FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')
                
                IF(ISNULL(@OldTagHistory,'') <> ISNULL(@TagHistory,''))
                BEGIN

                   DECLARE @TempAuditId UNIQUEIDENTIFIER = (SELECT AuditComplianceId FROM AuditConduct WHERE Id = @ConductId)

                   INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							SELECT NEWID(), @TempAuditId, @ConductId, NULL, @OldTagHistory, @TagHistory, 'ConductTagsUpdated', GETDATE(), @OperationsPerformedBy 

                END

       --     IF(@TagsXml IS NULL)
       --         INSERT INTO [dbo].[AuditQuestionHistory]([Id], [AuditId], [ConductId], [QuestionId], [OldValue], [NewValue], [Description], [CreatedDateTime], [CreatedByUserId])
							--SELECT NEWID(), @AuditId, NULL, NULL, NULL, NULL, 'AuditTagsUpdated', GETDATE(), @OperationsPerformedBy

          SELECT AG.AuditConductId FROM AuditTags AG JOIN #Tags T ON T.AuditId = AG.AuditId GROUP BY AG.AuditConductId

		   END
        END
        ELSE
            RAISERROR(@HavePermission,11,1)

    END TRY
    BEGIN CATCH

        THROW

    END CATCH
END