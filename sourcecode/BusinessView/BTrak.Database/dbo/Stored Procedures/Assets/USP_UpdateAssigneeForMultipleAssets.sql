CREATE PROCEDURE [dbo].[USP_UpdateAssigneeForMultipleAssets]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @AssetIds NVARCHAR(MAX),
 @AssignedToEmployeeId UNIQUEIDENTIFIER,
 @AssignedDateFrom DATE = NULL,
 @ApprovedByUserId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @AssetList NVARCHAR(MAX) = NULL

		DECLARE @Cnt INT = (SELECT COUNT(1) FROM AssetAssignedToEmployee WHERE AssetId IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AssetIds,',')) AND AssignedDateFrom > @AssignedDateFrom AND @AssignedDateFrom IS NOT NULL AND AssignedDateTo IS NULL)

		IF(ISNULL(@Cnt,0) = 0)
		BEGIN
			
			IF(@AssignedDateFrom IS NULL)
			BEGIN

				SET @AssignedDateFrom = GETDATE()

			END

			CREATE TABLE #Temp(
							   AssetId UNIQUEIDENTIFIER,
							   ApproveById UNIQUEIDENTIFIER,
							   ApprovedByName NVARCHAR(MAX),
							   AssignedEmployeeId UNIQUEIDENTIFIER,
							   AssigneeName NVARCHAR(MAX),
							   FullName NVARCHAR(MAX),
							   ApprovedByChange BIT,
							   AssigneeChange BIT
						       )
			
			INSERT INTO #Temp(AssetId,ApproveById,AssignedEmployeeId)
			SELECT T.[Value],AAE.ApprovedByUserId,AAE.AssignedToEmployeeId FROM AssetAssignedToEmployee AAE JOIN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AssetIds,',')) T ON T.[Value] = AAE.AssetId AND AAE.AssignedDateTo IS NULL

			UPDATE #Temp SET ApprovedByChange = IIF(ApproveById = @ApprovedByUserId,0,1),AssigneeChange = IIF(AssignedEmployeeId = @AssignedToEmployeeId,0,1) FROM #Temp T JOIN AssetAssignedToEmployee AAE ON T.AssetId = AAE.AssetId

			UPDATE #Temp SET ApprovedByName = U.FirstName + ' ' + ISNULL(U.SurName,'') FROM #Temp T JOIN [User] U ON U.Id = T.ApproveById
			
			UPDATE #Temp SET AssigneeName = U.FirstName + ' ' + ISNULL(U.SurName,'') FROM #Temp T JOIN [User] U ON U.Id = T.AssignedEmployeeId
			
			UPDATE #Temp SET FullName = U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE U.Id = @OperationsPerformedBy

			UPDATE AssetAssignedToEmployee SET UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE(),ApprovedByUserId = @ApprovedByUserId,AssignedDateFrom = @AssignedDateFrom WHERE AssetId IN (SELECT AssetId FROM #Temp WHERE AssigneeChange = 0)
			
			UPDATE AssetAssignedToEmployee SET UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE(),AssignedToEmployeeId = @AssignedToEmployeeId,AssignedDateFrom = @AssignedDateFrom WHERE AssetId IN (SELECT AssetId FROM #Temp WHERE ApprovedByChange = 0 AND AssigneeChange = 0)
			
			UPDATE AssetAssignedToEmployee SET UpdatedByUserId = @OperationsPerformedBy,UpdatedDateTime = GETDATE(),AssignedDateTo = @AssignedDateFrom WHERE AssetId IN (SELECT AssetId FROM #Temp WHERE AssigneeChange = 1)

			INSERT INTO [dbo].[AssetAssignedToEmployee](
									[Id],
									[AssetId],
									[AssignedToEmployeeId],
									[AssignedDateFrom],
									[ApprovedByUserId],
									[CreatedDateTime],
									[CreatedByUserId]
									)
							  SELECT NEWID(),
									 AssetId,
									 @AssignedToEmployeeId,
									 @AssignedDateFrom,
									 @ApprovedByUserId,
									 GETDATE(),
									 @OperationsPerformedBy
									 FROM #Temp T WHERE T.AssigneeChange = 1

			  --history for assignee change
			  INSERT INTO [dbo].[AssetHistory](
                                               [Id],
                                               [AssetId],
                                               [AssetHistoryJson],
                                               [CreatedByUserId],
                                               [CreatedDateTime])
                                        SELECT NEWID(),
                                               AssetId,
                                               (SELECT 'AssignedToEmployeeId' AS FieldName,AssignedEmployeeId AS OldValue,@AssignedToEmployeeId AS NewValue,AssigneeName AS OldValueText,(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE Id = @AssignedToEmployeeId) AS NewValueText,'AssetAssignedToEmployeeChange' AS [Description],FullName FROM #Temp WHERE AssigneeChange = 1 AND AssetId = T.AssetId FOR JSON PATH,ROOT('AssetsFieldsChangedList')),
                                               @OperationsPerformedBy,
                                               GETDATE()
											   FROM #Temp T WHERE AssigneeChange = 1

			  --history for approved change
			  IF(@ApprovedByUserId IS NOT NULL)
			  BEGIN
			  INSERT INTO [dbo].[AssetHistory](
                                               [Id],
                                               [AssetId],
                                               [AssetHistoryJson],
                                               [CreatedByUserId],
                                               [CreatedDateTime])
                                        SELECT NEWID(),
                                               AssetId,
                                               (SELECT 'ApprovedByUserId' AS FieldName,AssignedEmployeeId AS OldValue,@ApprovedByUserId AS NewValue,AssigneeName AS OldValueText,(SELECT U.FirstName + ' ' + ISNULL(U.SurName,'') FROM [User] U WHERE Id = @AssignedToEmployeeId) AS NewValueText,'AssetApprovedByUserChange' AS [Description],FullName FROM #Temp WHERE ApprovedByChange = 1 AND AssetId = T.AssetId FOR JSON PATH,ROOT('AssetsFieldsChangedList')),
                                               @OperationsPerformedBy,
                                               GETDATE()
											   FROM #Temp T WHERE ApprovedByChange = 1
			  END
			  
			  SELECT AAE.AssetId,A.AssetName,A.AssetNumber,ISNULL(@Cnt,0) AS FailedCount FROM Asset A JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND AAE.AssignedDateTo IS NULL
			  WHERE A.Id IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AssetIds,','))
		END
		ELSE
		BEGIN
			SELECT AAE.AssetId,A.AssetName,A.AssetNumber,ISNULL(@Cnt,0) AS FailedCount FROM Asset A JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND AAE.AssignedDateFrom > @AssignedDateFrom AND AAE.AssignedDateTo IS NULL
			 WHERE A.Id IN (SELECT [Value] FROM [dbo].[Ufn_StringSplit](@AssetIds,','))
	    END

	END TRY
	BEGIN CATCH

		THROW

	END CATCH
END
GO