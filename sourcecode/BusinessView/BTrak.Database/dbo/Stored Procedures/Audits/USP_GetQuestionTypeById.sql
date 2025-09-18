CREATE PROCEDURE [dbo].[USP_GetQuestionTypeById]
(
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @SearchText NVARCHAR(250)  = NULL,
   @IsArchived BIT = 0,
   @QuestionTypeName NVARCHAR(250) = NULL,
   @QuestionTypeId UNIQUEIDENTIFIER = NULL,
   @MasterQuestionTypeId UNIQUEIDENTIFIER = NULL
 )
AS
BEGIN

   SET NOCOUNT ON

   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

   DECLARE @HavePermission NVARCHAR(250)  = 1--(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

			IF(@SearchText = '') SET @SearchText = NULL

           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           
		   IF(@IsArchived IS NULL)SET @IsArchived = 0
		   SELECT Qt.Id AS QuestionTypeId,
				 Qt.QuestionTypeName,
				 Qt.CreatedByUserId,
				 Qt.CreatedDateTime,
				 Qt.[TimeStamp],
				 Qt.MasterQuestionTypeId,
				 MQT.MasterQuestionTypeName,
                 IIF(EXISTS(SELECT Id FROM AuditQuestions AQ1 WHERE AQ1.QuestionTypeId = QT.Id AND AQ1.InactiveDateTime IS NULL),1,0) AS CanQuestionTypeDeleted,
				 (SELECT [dbo].[Ufn_ToString]((SELECT QuestionTypeOptionName AS [row] FROM QuestionTypeOptions WHERE QuestionTypeId = QT.Id AND InActiveDateTime IS NULL ORDER BY QuestionTypeOptionOrder FOR XML PATH('')),',')) AS QuestionTypeOptionName,
				 (SELECT Id AS QuestionTypeOptionId,
				         QuestionTypeOptionName,
						 QuestionTypeOptionOrder,
						 CAST(QuestionTypeOptionScore AS numeric(10,2)) AS QuestionTypeOptionScore,
						  IIF(EXISTS(SELECT Id FROM AuditAnswers WHERE QuestionTypeOptionId = QTO.Id AND InactiveDateTime IS NULL AND QuestionOptionResult = 1)
                            ,1,0) AS CanQuestionTypeOptionDeleted
				        FROM QuestionTypeOptions QTO WHERE QTO.QuestionTypeId = Qt.Id AND QTO.InActiveDateTime IS NULL
						ORDER BY QTO.QuestionTypeOptionOrder
						FOR XML PATH('QuestionTypeOptionsModel'), ROOT('QuestionTypeOptionsModel'), TYPE) AS QuestionTypeOptionsXml,
				 (CASE WHEN Qt.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived
		  FROM QuestionTypes Qt
		  JOIN MasterQuestionType MQT ON MQt.Id = Qt.MasterQuestionTypeId
		  WHERE Qt.CompanyId = @CompanyId --AND ISNULL(QT.IsFromMasterQuestionType,0) = 0
		        AND (@QuestionTypeId IS NULL OR QT.Id = @QuestionTypeId)
				AND (@QuestionTypeName IS NULL OR QT.QuestionTypeName = @QuestionTypeName)
				AND (@SearchText IS NULL OR QT.QuestionTypeName LIKE  '%'+ @SearchText +'%' OR MQT.MasterQuestionTypeName LIKE '%' + @SearchText + '%')
				AND ((ISNULL(@IsArchived,0) = 1 AND QT.InActiveDateTime IS NOT NULL) 
					OR (ISNULL(@IsArchived,0) = 0 AND QT.InActiveDateTime IS NULL))
		 ORDER BY QuestionTypeName ASC
       	   
		END
      END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END
GO
