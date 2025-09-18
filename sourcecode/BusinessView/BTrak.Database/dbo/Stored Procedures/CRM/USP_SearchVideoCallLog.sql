CREATE PROCEDURE [dbo].[USP_SearchVideoCallLog]
(
	@VideoCallLogId UNIQUEIDENTIFIER = NULL,
	@CompositionSid NVARCHAR(200) = NULL,
	@ReceiverId UNIQUEIDENTIFIER = NULL,
	@VideoRecordingLink NVARCHAR(MAX) = null,
	@FileName NVARCHAR(1000) = NULL,
	@Extension NVARCHAR(100) = NULL,
	@Type NVARCHAR(100) = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

	SET NOCOUNT ON

	BEGIN TRY
		SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @CompanyId UNIQUEIDENTIFIER = NULL

		IF(@OperationsPerformedBy IS NOT NULL)
		BEGIN
			
			SET @CompanyId = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		END

			SELECT C.Id AS VideoCallLogId,
				   C.ReceiverId AS ReceiverId,
				   C.VideoRecordingLink AS VideoRecordingLink,
				   C.[FileName] AS [FileName],
				   C.[Type] AS [Type],
				   C.[Extension] AS [Extension],
				   U.FirstName +' '+ U.SurName AS [UserName],
				   U.ProfileImage,
				   U.Id AS UserId,
				   C.CompositionSid,
				   C.RoomSid,
				   C.CompanyId,
				   C.RoomName,
				   C.CreatedDateTime
			FROM [dbo].[CRMVideoLog] AS C
			JOIN [User] AS U ON U.Id = C.CreatedByUserId
			WHERE (@ReceiverId IS NULL OR C.ReceiverId = @ReceiverId)
				AND (@CompanyId IS NULL OR C.CompanyId = @CompanyId)
				AND (@CompositionSid IS NULL OR C.CompositionSid = @CompositionSid)
				AND (C.CompositionSid IS NOT NULL OR C.[FileName] IS NOT NULL)
			ORDER BY C.CreatedDateTime DESC


	END TRY
	BEGIN CATCH 
		
		EXEC USP_GetErrorInformation

	END CATCH

END