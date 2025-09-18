CREATE PROCEDURE [dbo].[USP_InsertProjectAuditHistory]
(
	@ProjectId UNIQUEIDENTIFIER = NULL,
	@ProjectName NVARCHAR(500) = NULL,
	@ProjectResponsiblePersonId UNIQUEIDENTIFIER = NULL,
	@ProjectTypeId UNIQUEIDENTIFIER = NULL,
	@IsDateTimeConfiguration BIT = NULL,
    @IsSprintsConfiguration BIT = NULL,
	@IsArchived BIT = NULL,
	@FeatureId UNIQUEIDENTIFIER = NULL,
	@FeatureName NVARCHAR(500) = NULL,
	@FeatureResponsiblePersonId UNIQUEIDENTIFIER = NULL,
	@ComponentIsArchived BIT = NULL,
	@ComponentResponsiblePersonIsDeleted BIT = NULL,
	@TemplateId UNIQUEIDENTIFIER = NULL,
	@TemplateName NVARCHAR(500) = NULL,
	@TemplateResponsibleUserId UNIQUEIDENTIFIER = NULL,
	@TemplateBoardTypeId UNIQUEIDENTIFIER = NULL,
	@TemplateOnBoardProcessDate DATETIMEOFFSET = NULL,
	@TimeZoneId UNIQUEIDENTIFIER = NULL,
	@TemplateIsArchived BIT = NULL,
	@ProjectMemberUserIds XML = NULL,
    @ProjectMemberRoleIds XML = NULL,
    @ProjectMemberIsArchived BIT = NULL,
	@ProjectMemberIsDeleted BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@ProjectStartDate DATETIMEOFFSET = NULL,
	@ProjectEndDate DATETIMEOFFSET = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	        DECLARE @OldProjectName NVARCHAR(800) = NULL

            DECLARE @OldProjectResponsiblePersonId UNIQUEIDENTIFIER = NULL
			
			DECLARE @OldProjectTypeId UNIQUEIDENTIFIER = NULL 

			DECLARE @OldIsDateTimeConfiguration BIT = NULL

            DECLARE @OldIsSprintsConfiguration BIT = NULL

			DECLARE @OldIsArchived BIT = NULL

			DECLARE @OldFeatureName NVARCHAR(500) = NULL

			DECLARE @OldFeatureResponsiblePersonId UNIQUEIDENTIFIER = NULL

			DECLARE @OldComponentIsArchived BIT = NULL

			DECLARE @OldComponentResponsiblePersonIsDeleted BIT = NULL

			DECLARE @OldTemplateName NVARCHAR(500) = NULL

			DECLARE @OldTemplateResponsibleUserId UNIQUEIDENTIFIER = NULL

			DECLARE @OldTemplateBoardTypeId UNIQUEIDENTIFIER = NULL

			DECLARE @OldTemplateOnBoardProcessDate DATETIMEOFFSET = NULL

			DECLARE @OldProjectId UNIQUEIDENTIFIER = NULL

			DECLARE @OldTemplateIsArchived BIT = NULL

			DECLARE @OldProjectStartDate DATETIMEOFFSET = NULL

			DECLARE @OldProjectEndDate DATETIMEOFFSET = NULL

		    SELECT @OldProjectName = ProjectName, @OldProjectResponsiblePersonId = ProjectResponsiblePersonId, @OldProjectTypeId = ProjectTypeId, @OldIsDateTimeConfiguration = IsDateTimeConfiguration,
			       @OldIsSprintsConfiguration = IsSprintsConfiguration, @OldIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0), @OldProjectStartDate = ProjectStartDate , @OldProjectEndDate = ProjectEndDate
			FROM Project WHERE Id = @ProjectId
		    
			SELECT @OldFeatureName = ProjectFeatureName, @OldComponentIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0)
			FROM [ProjectFeature] WHERE ProjectId = @ProjectId AND Id = @FeatureId

			SELECT @OldFeatureResponsiblePersonId = UserId, @OldComponentResponsiblePersonIsDeleted = IsDelete
			FROM [dbo].[ProjectFeatureResponsiblePerson] WHERE ProjectFeatureId = @FeatureId

			SELECT @OldTemplateName = TemplateName, @OldTemplateResponsibleUserId = TemplateResponsibleUserId, @OldTemplateBoardTypeId = BoardTypeId, @OldProjectId = ProjectId,
			       @OldTemplateOnBoardProcessDate = OnBoardProcessDate, @OldTemplateIsArchived = IIF(InActiveDateTime IS NOT NULL,1,0)
			FROM Templates WHERE Id = @TemplateId

		    DECLARE @Currentdate DATETIME = GETDATE()

		    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		    
	        DECLARE @OldValue NVARCHAR(500)

		    DECLARE @NewValue NVARCHAR(500)

		    DECLARE @FieldName NVARCHAR(200)

		    DECLARE @HistoryDescription NVARCHAR(800)

			IF(@OldProjectName <> @ProjectName)
		    BEGIN

		        SET @OldValue = @OldProjectName

		        SET @NewValue = @ProjectName

		        SET @FieldName = 'ProjectName'	

		        SET @HistoryDescription = 'ProjectNameChanged'
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
		    END

		    IF(@OldProjectResponsiblePersonId <> @ProjectResponsiblePersonId)
		    BEGIN
		       
		        SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldProjectResponsiblePersonId AND IsActive = 1)

		        SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @ProjectResponsiblePersonId AND IsActive = 1)

		        SET @FieldName = 'ProjectResponsiblePerson'	

		        SET @HistoryDescription = 'ProjectResponsiblePersonChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldProjectTypeId <> @ProjectTypeId)
		    BEGIN
		       
		        SET @OldValue = (SELECT ProjectTypeName FROM ProjectType WHERE Id = @OldProjectTypeId)
		        SET @NewValue = (SELECT ProjectTypeName FROM ProjectType WHERE Id = @ProjectTypeId)

		        SET @FieldName = 'ProjectType'	

		        SET @HistoryDescription = 'ProjectTypeChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldIsDateTimeConfiguration <> @IsDateTimeConfiguration)
		    BEGIN
		       
		        SET @OldValue = IIF(@OldIsDateTimeConfiguration IS NULL,'',IIF(@OldIsDateTimeConfiguration = 0,'No','Yes'))
		        SET @NewValue = IIF(@IsDateTimeConfiguration IS NULL,'',IIF(@IsDateTimeConfiguration = 0,'No','Yes'))

		        SET @FieldName = 'DateTimeConfiguration'	

		        SET @HistoryDescription = 'DateTimeConfigurationChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldIsSprintsConfiguration <> @IsSprintsConfiguration)
		    BEGIN
		       
		        SET @OldValue = IIF(@OldIsSprintsConfiguration IS NULL,'',IIF(@OldIsSprintsConfiguration = 0,'No','Yes'))
		        SET @NewValue = IIF(@IsSprintsConfiguration IS NULL,'',IIF(@IsSprintsConfiguration = 0,'No','Yes'))

		        SET @FieldName = 'SprintsConfiguration'	

		        SET @HistoryDescription = 'SprintsConfigurationChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF (((@OldProjectStartDate <> @ProjectStartDate) OR (@OldProjectStartDate IS NULL AND @ProjectStartDate IS NOT NULL))
							AND ((@OldProjectEndDate <> @ProjectEndDate) OR (@OldProjectEndDate IS NULL AND @ProjectEndDate IS NOT NULL))
						   )
                        BEGIN
                            SET @OldValue = CONVERT(NVARCHAR(500), FORMAT(@OldProjectStartDate, 'dd/MM/yyyy')) + ' - ' + CONVERT(NVARCHAR(500), FORMAT(@OldProjectEndDate, 'dd/MM/yyyy'))
                            SET @NewValue = CONVERT(NVARCHAR(500), FORMAT(@ProjectStartDate, 'dd/MM/yyyy')) + ' - ' + CONVERT(NVARCHAR(500), FORMAT(@ProjectEndDate, 'dd/MM/yyyy'))
                            SET @FieldName = 'Project Start And End Date'
                            SET @HistoryDescription = 'ProjectStartAndEndDateChanged'
                            EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
                        END

			IF(@OldIsArchived <> @IsArchived)
		    BEGIN
		       
		        SET @OldValue = IIF(@OldIsArchived IS NULL,'',IIF(@OldIsArchived = 0,'No','Yes'))
		        SET @NewValue = IIF(@IsArchived IS NULL,'',IIF(@IsArchived = 0,'No','Yes'))

		        SET @FieldName = 'ProjectArchived'	

		        SET @HistoryDescription = 'ProjectArchived'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldFeatureName <> @FeatureName)
		    BEGIN

		        SET @OldValue = @OldFeatureName

		        SET @NewValue = @FeatureName

		        SET @FieldName = 'ComponentName'	

		        SET @HistoryDescription = 'ComponentNameChanged'
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @FeatureId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldFeatureResponsiblePersonId <> @FeatureResponsiblePersonId)
		    BEGIN
		       
		        SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldFeatureResponsiblePersonId AND IsActive = 1)

		        SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @FeatureResponsiblePersonId AND IsActive = 1)

		        SET @FieldName = 'ComponentResponsiblePerson'	

		        SET @HistoryDescription = 'ComponentResponsiblePersonChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @FeatureId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldComponentIsArchived <> @ComponentIsArchived)
		    BEGIN
		       
		        SET @OldValue = IIF(@OldComponentIsArchived IS NULL,'',IIF(@OldComponentIsArchived = 0,'No','Yes'))
		        SET @NewValue = IIF(@ComponentIsArchived IS NULL,'',IIF(@ComponentIsArchived = 0,'No','Yes'))

		        SET @FieldName = 'ComponentArchived'	

		        SET @HistoryDescription = 'ComponentArchived'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @FeatureId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldComponentResponsiblePersonIsDeleted <> @ComponentResponsiblePersonIsDeleted)
		    BEGIN
		       
		        SET @OldValue = IIF(@OldComponentResponsiblePersonIsDeleted IS NULL,'',IIF(@OldComponentResponsiblePersonIsDeleted = 0,'No','Yes'))
		        SET @NewValue = IIF(@ComponentResponsiblePersonIsDeleted IS NULL,'',IIF(@ComponentResponsiblePersonIsDeleted = 0,'No','Yes'))

		        SET @FieldName = 'ComponentResponsiblePersonDeleted'	

		        SET @HistoryDescription = 'ComponentResponsiblePersonDeleted'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @FeatureId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldTemplateName <> @TemplateName)
		    BEGIN

		        SET @OldValue = @OldTemplateName

		        SET @NewValue = @TemplateName

		        SET @FieldName = 'TemplateName'	

		        SET @HistoryDescription = 'TemplateNameChanged'
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldTemplateResponsibleUserId <> @TemplateResponsibleUserId)
		    BEGIN
		       
		        SET @OldValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @OldTemplateResponsibleUserId AND IsActive = 1)

		        SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @TemplateResponsibleUserId AND IsActive = 1)

		        SET @FieldName = 'TemplateResponsiblePerson'	

		        SET @HistoryDescription = 'TemplateResponsiblePersonChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldTemplateBoardTypeId <> @TemplateBoardTypeId)
		    BEGIN
		       
		        SET @OldValue = (SELECT BoardTypeName FROM BoardType WHERE Id = @OldTemplateBoardTypeId)
		        SET @NewValue = (SELECT BoardTypeName FROM BoardType WHERE Id = @TemplateBoardTypeId)

		        SET @FieldName = 'BoardType'	

		        SET @HistoryDescription = 'BoardTypeChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldTemplateOnBoardProcessDate <> @TemplateOnBoardProcessDate)
		    BEGIN

		        SET @OldValue = @OldTemplateOnBoardProcessDate

		        SET @NewValue = @TemplateOnBoardProcessDate

		        SET @FieldName = 'TemplateOnBoardProcessDate'	

		        SET @HistoryDescription = 'TemplateOnBoardProcessDateChanged'
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldTemplateIsArchived <> @TemplateIsArchived)
		    BEGIN
		       
		        SET @OldValue = IIF(@OldTemplateIsArchived IS NULL,'',IIF(@OldTemplateIsArchived = 0,'No','Yes'))
		        SET @NewValue = IIF(@TemplateIsArchived IS NULL,'',IIF(@TemplateIsArchived = 0,'No','Yes'))

		        SET @FieldName = 'TemplateArchived'	

		        SET @HistoryDescription = 'TemplateArchived'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId,@TimeZoneId = @TimeZoneId
		    
		    END

			IF(@OldProjectId <> @ProjectId)
		    BEGIN
		       
		        SET @OldValue = (SELECT ProjectName FROM Project WHERE Id = @OldProjectId)
		        SET @NewValue = (SELECT ProjectName FROM Project WHERE Id = @ProjectId)

		        SET @FieldName = 'TemplateProject'	

		        SET @HistoryDescription = 'TemplateProjectChanged'		
		        
		        EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                      @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @TemplateId,@TimeZoneId = @TimeZoneId
		    
		    END

			DECLARE @ProjectMembersTable TABLE
            (
                UserProjectId UNIQUEIDENTIFIER DEFAULT NEWSEQUENTIALID(),
                UserId UNIQUEIDENTIFIER,
                RoleId UNIQUEIDENTIFIER
            )
        
            INSERT INTO @ProjectMembersTable(UserId,RoleId)
            SELECT x.y.value('(text())[1]', 'varchar(100)'),x1.y1.value('(text())[1]', 'varchar(100)')
            FROM @ProjectMemberUserIds.nodes('/GenericListOfGuid/*/guid') AS x(y),
                 @ProjectMemberRoleIds.nodes('/GenericListOfGuid/*/guid') AS x1(y1)

			IF(@ProjectMemberUserIds IS NOT NULL)
			BEGIN

				DECLARE @UserId UNIQUEIDENTIFIER

				DECLARE User_CURSOR CURSOR FOR  
				SELECT DISTINCT UserId FROM @ProjectMembersTable

				OPEN User_CURSOR   
				FETCH NEXT FROM User_CURSOR INTO @UserId

				WHILE @@FETCH_STATUS = 0   
				BEGIN   

					IF((SELECT COUNT(1) FROM UserProject WHERE ProjectId = @ProjectId AND UserId = @UserId AND InActiveDateTime IS NULL) = 0)
					BEGIN

						SET @OldValue = ''

						SET @NewValue = (SELECT FirstName + ' ' + ISNULL(SurName,'') FROM [User] WHERE Id = @UserId AND IsActive = 1)

						SET @FieldName = 'ProjectMemberAdded'	

						SET @HistoryDescription = 'ProjectMemberAdded'		
						
						EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                              @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId

					END
					ELSE IF((SELECT COUNT(1) FROM UserProject WHERE ProjectId = @ProjectId AND UserId = @UserId AND InActiveDateTime IS NULL) > 0)
					BEGIN

						SET @OldValue =  (SELECT STUFF((SELECT ', ' + CAST(ER.EntityRoleName AS VARCHAR(MAX)) [text()]
										 FROM UserProject UP
										      INNER JOIN EntityRole ER ON ER.Id = UP.EntityRoleId
										 WHERE ProjectId = @ProjectId AND UserId = @UserId AND UP.InActiveDateTime IS NULL
										 FOR XML PATH(''), TYPE)
										.value('.','NVARCHAR(MAX)'),1,2,' '))

						SET @NewValue = (SELECT STUFF((SELECT ', ' + CAST(ER.EntityRoleName AS VARCHAR(MAX)) [text()]
										 FROM @ProjectMembersTable UP
										      INNER JOIN EntityRole ER ON ER.Id = UP.RoleId
										 WHERE UserId = @UserId
										 FOR XML PATH(''), TYPE)
										.value('.','NVARCHAR(MAX)'),1,2,' '))

						SET @FieldName = 'ProjectRole'	

						SET @HistoryDescription = 'ProjectRoleChanged'		
						
						EXEC USP_InsertProjectHistory @ProjectId = @ProjectId, @OldValue = @OldValue, @NewValue = @NewValue, @FieldName = @FieldName,
		                                              @Description = @HistoryDescription, @OperationsPerformedBy = @OperationsPerformedBy, @ReferenceId = @ProjectId,@TimeZoneId = @TimeZoneId

					END

					FETCH NEXT FROM User_CURSOR INTO @UserId   
				END   

				CLOSE User_CURSOR   
				DEALLOCATE User_CURSOR

			END

	END TRY
	BEGIN CATCH

	    	THROW

	END CATCH

END
GO
