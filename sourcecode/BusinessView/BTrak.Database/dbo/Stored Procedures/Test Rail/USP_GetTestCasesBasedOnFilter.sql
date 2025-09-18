CREATE PROCEDURE [dbo].[USP_GetTestCasesbasedOnFilter]
(
	@TestCaseId UNIQUEIDENTIFIER = NULL,
	@AutomationTypeId UNIQUEIDENTIFIER = NULL,
	@CreatedByUserId UNIQUEIDENTIFIER = NULL,
	@CreatedOn NVARCHAR(50) = NULL,
	@CreatedDateFrom DATETIME = NULL,
	@CreatedDateTo DATETIME = NULL,
	@PriorityId UNIQUEIDENTIFIER = NULL,
	@SectionId UNIQUEIDENTIFIER = NULL,
	@TemplateId UNIQUEIDENTIFIER = NULL,
	@TypeId UNIQUEIDENTIFIER = NULL,
	@UpdatedByUserId UNIQUEIDENTIFIER = NULL,
	@UpdatedOn NVARCHAR(50) = NULL,
	@UpdatedDateFrom DATETIME = NULL,
	@UpdatedDateTo DATETIME = NULL,
	@IsMatchAllEstimate BIT = NULL,
	@EstimateXml XML = NULL,
	@IsMatchAllReferences BIT = NULL,
	@ReferencesXml XML = NULL,
	@IsMatchAllTitle BIT = NULL,
	@TitleXml XML = NULL,
	@IsMatchAll BIT = NULL
)
AS 
   BEGIN
   
   IF(@TestCaseId = '00000000-0000-0000-0000-000000000000') SET @TestCaseId = NULL

   IF(@AutomationTypeId = '00000000-0000-0000-0000-000000000000') SET @AutomationTypeId = NULL

   IF(@CreatedByUserId = '00000000-0000-0000-0000-000000000000') SET @CreatedByUserId = NULL

   IF(@CreatedOn = '') SET @CreatedOn = NULL

   IF(@CreatedDateFrom = '') SET @CreatedDateFrom = NULL

   IF(@CreatedDateTo = '') SET @CreatedDateTo = NULL

   IF(@PriorityId = '00000000-0000-0000-0000-000000000000') SET @PriorityId = NULL

   IF(@SectionId = '00000000-0000-0000-0000-000000000000') SET @SectionId = NULL

   IF(@TemplateId = '00000000-0000-0000-0000-000000000000') SET @TemplateId = NULL

   IF(@TypeId = '00000000-0000-0000-0000-000000000000') SET @TypeId = NULL

   IF(@UpdatedByUserId = '00000000-0000-0000-0000-000000000000') SET @UpdatedByUserId = NULL

   IF(@UpdatedDateTo = '') SET @UpdatedDateTo = NULL

	SET @EstimateXml = CAST(@EstimateXml AS XML)
	SET @ReferencesXml = CAST(@ReferencesXml AS XML)
	SET @TitleXml = CAST(@TitleXml AS XML)

	DECLARE @Temp TABLE
	(
		FilterType NVARCHAR(100),
		FilterDate NVARCHAR(250)
	)

	DECLARE @TestCases TABLE 
	(
		Id UNIQUEIDENTIFIER
	)

	--IF(@CreatedOn <> 'Custom')
		--SELECT @CreatedDateFrom =DateFrom,@CreatedDateTo = DateTo FROM Ufn_ReturnStartAndEndDates (@CreatedOn)

	--IF(@UpdatedOn <> 'Custom')
		--SELECT @UpdatedDateFrom =DateFrom,@UpdatedDateTo = DateTo FROM Ufn_ReturnStartAndEndDates (@UpdatedOn)

	
	DECLARE @Type VARCHAR(50)
	DECLARE @Data VARCHAR(250)

	IF(@IsMatchAll = 1)
		BEGIN
			
			--DELETE @Temp

			INSERT INTO @Temp 
			SELECT [Table].[Column].value(' FilterType[1]', 'varchar(500)'),
				   [Table].[Column].value(' MatchWord[1]', 'varchar(500)') 
			FROM @TitleXml.nodes('/ArrayOfMatchModels/MatchModels') as [Table]([Column])

			DECLARE db_cursor CURSOR FOR SELECT FilterType, FilterDate FROM @Temp 
			OPEN db_cursor
			FETCH NEXT FROM db_cursor INTO @Type, @Data
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
			
			       IF(@Type = 'IS')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC  
						WHERE (@Data IS NULL OR TC.[Title] = @Data)

				   END
				   ELSE IF(@Type = 'IS NOT')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC JOIN @TestCases temp ON TC.Id = temp.Id
						WHERE (@Data IS NULL OR TC.[Title] <> @Data)

						SELECT * FROM @TestCases

				   END
				   ELSE IF(@Type = 'Contains')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC
						WHERE (@Data IS NULL OR (TC.[Title] LIKE @Data))

				   END
				   ELSE IF(@Type = 'Doesnot Contain')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC
						WHERE (@Data IS NULL OR (TC.[Title] NOT LIKE @Data))

				   END
			
			       FETCH NEXT FROM db_cursor INTO @Type, @Data

			END
			CLOSE db_cursor
			DEALLOCATE db_cursor

			DELETE @Temp

			INSERT INTO @Temp 
			SELECT [Table].[Column].value(' FilterType[1]', 'varchar(500)'),
				   [Table].[Column].value(' MatchWord[1]', 'varchar(500)') 
			FROM @ReferencesXml.nodes('/ArrayOfMatchModels/MatchModels') as [Table]([Column])

			DECLARE db_cursor CURSOR FOR SELECT FilterType, FilterDate FROM @Temp 
			OPEN db_cursor
			FETCH NEXT FROM db_cursor INTO @Type, @Data
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
			
			       IF(@Type = 'IS')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC  
						WHERE (@Data IS NULL OR TC.[References] = @Data)

				   END
				   ELSE IF(@Type = 'IS NOT')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC
						WHERE (@Data IS NULL OR TC.[References] <> @Data)

				   END
				   ELSE IF(@Type = 'Contains')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC
						WHERE (@Data IS NULL OR (TC.[References] LIKE @Data))

				   END
				   ELSE IF(@Type = 'Doesnot Contain')
				   BEGIN

						INSERT @TestCases
						SELECT TC.Id FROM TestCase TC
						WHERE (@Data IS NULL OR (TC.[References] NOT LIKE @Data))

				   END

			       FETCH NEXT FROM db_cursor INTO @Type, @Data

			END
			CLOSE db_cursor
			DEALLOCATE db_cursor

			INSERT @TestCases
			SELECT  TC.Id
			FROM TestCase TC WITH (NOLOCK) INNER JOIN @TestCases temp ON temp.Id = TC.Id 
			WHERE InActiveDateTime IS NULL
			 AND (@AutomationTypeId IS NULL OR  AutomationTypeId = @AutomationTypeId)						
			 AND (@CreatedByUserId IS NULL OR CreatedByUserId = @CreatedByUserId)
			 AND (CONVERT(DATE,CreatedDateTime) >= @CreatedDateFrom OR @CreatedDateFrom IS NULL) 
			 AND (CONVERT(DATE,CreatedDateTime) <= @CreatedDateTo OR @CreatedDateTo IS NULL)
			 AND (@PriorityId  IS NULL OR PriorityId = @PriorityId)
			 AND (@SectionId IS NULL OR SectionId = @SectionId)
			 AND (@TemplateId IS NULL OR TemplateId = @TemplateId)
			 AND (@TypeId IS NULL OR TypeId = @TypeId)
			 AND (@TestCaseId IS NULL OR TC.Id = @TestCaseId)

		END

	SELECT DISTINCT TC.[Id]
      ,TC.[Title]
      ,TC.[SectionId]
      ,TC.[TemplateId]
      ,TC.[TypeId]
      ,TC.[Estimate]
      ,TC.[References]
      ,TC.[Steps]
      ,TC.[ExpectedResult]
      ,(CASE WHEN TC.InActiveDateTime IS NULL THEN 0 ELSE 1 END) AS IsArchived
      ,TC.[CreatedDateTime]
      ,TC.[CreatedByUserId]
      ,TC.[Mission]
      ,TC.[Goals]
      ,TC.[PriorityId]
      ,TC.[AutomationTypeId]
      ,TC.[TestCaseId]
      ,TC.[TestSuiteId]
      ,TC.[PreCondition] FROM @TestCases Temp JOIN TestCase TC ON Temp.Id = TC.Id

END
GO