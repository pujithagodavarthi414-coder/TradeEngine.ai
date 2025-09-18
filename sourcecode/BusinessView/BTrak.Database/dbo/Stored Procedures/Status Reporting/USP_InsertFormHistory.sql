-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-02-01 00:00:00.000'
-- Purpose      To Insert Form History
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
 --EXEC [dbo].[USP_InsertFormHistory] @OperationsPerformedBy='0b2921a9-e930-4013-9047-670b5352f308',@GenericFormSubmittedId = 'cc2947ef-90fd-4625-8afe-c428fdf2bd8f'
--,@HistoryXml = '<GenericListOfHistoryOutputModel><ListItems>
--<HistoryOutputModel><Field>name</Field><OldValue>cvdfsdfdsedsda</OldValue><NewValue>cvdfsdfdsda</NewValue></HistoryOutputModel><HistoryOutputModel><Field>lastName</Field><OldValue>dsee2</OldValue><NewValue>d2</NewValue></HistoryOutputModel><HistoryOutputModel><Field>aboutYourSelf</Field><OldValue>aseesfsd</OldValue><NewValue>asfsd</NewValue></HistoryOutputModel></ListItems></GenericListOfHistoryOutputModel>'

CREATE PROCEDURE [dbo].[USP_InsertFormHistory]
(
	@HistoryXml XML,
	@GenericFormSubmittedId UNIQUEIDENTIFIER,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
		IF (@HavePermission = '1')
        BEGIN

		IF(@GenericFormSubmittedId = '00000000-0000-0000-0000-000000000000') SET @GenericFormSubmittedId = NULL

		INSERT INTO [FormHistory](Id,GenericFormSubmittedId,FieldName,OldFieldValue,NewFieldValue,CreatedByUserId,CreatedDateTime)
		SELECT NEWID()
		       ,@GenericFormSubmittedId
			   ,X.Y.value('Field[1]','NVARCHAR(250)')
			   ,X.Y.value('OldValue[1]','NVARCHAR(MAX)')
			   ,X.Y.value('NewValue[1]','NVARCHAR(MAX)')
			   ,@OperationsPerformedBy
			   ,GETDATE()
			FROM @HistoryXml.nodes('GenericListOfHistoryOutputModel/ListItems/HistoryOutputModel')  AS X(Y)

	END
	END TRY
	BEGIN CATCH
		
		THROW

	END CATCH

END
GO