-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Get SeatingArrangements By SeatingArrangementId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get SeatingArrangements By SeatingArrangementId
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXECUTE USP_GetSeatingArrangementsById @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971',@SeatingId = 'E053B834-7D4B-40B9-AD6A-3320A5306A13'

CREATE PROCEDURE [dbo].[USP_GetSeatingArrangementsById]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@SeatingId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    SET NOCOUNT ON
     BEGIN TRY
	 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

        DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

        SELECT SA.Id AS SeatingId,
			   SA.EmployeeId,
			   SA.SeatCode,
			   SA.[Description],
			   SA.Comment,
			   U.FirstName,
			   U.SurName,
			   U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName,
			   U.ProfileImage AS EmployeeProfileImage,
			   SA.CreatedDateTime,
			   SA.CreatedByUserId,
			   CASE WHEN SA.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived
        FROM [SeatingArrangement] AS SA
		    INNER JOIN [User] U ON SA.EmployeeId = U.Id
        WHERE (@SeatingId IS NULL OR SA.Id = @SeatingId)
		      AND U.CompanyId = @CompanyId
    
    END TRY
    BEGIN CATCH
        
         EXEC [dbo].[USP_GetErrorInformation]

    END CATCH
END
GO