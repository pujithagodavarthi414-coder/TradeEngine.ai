-------------------------------------------------------------------------------
-- Author       Sai Praneeth M
-- Created      '2019-02-20 00:00:00.000'
-- Purpose      To Get SeatingArrangements  SELECT * from [uSER]
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- Modified By   Geetha Ch
-- Created      '2019-03-15 00:00:00.000'
-- Purpose      To Get SeatingArrangements
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXECUTE USP_GetSeatingArrangements @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetSeatingArrangements]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @BranchId UNIQUEIDENTIFIER = NULL,
    @Pagesize INT = NULL,
    @Pagenumber INT = NULL,
    @EmployeeId UNIQUEIDENTIFIER = NULL,
    @IsArchived BIT = NULL,
    @SeatCode NVARCHAR(50) = NULL,
    @SortBy NVARCHAR(100) = NULL,
    @SortDirection VARCHAR(50)=NULL,
    @SearchText NVARCHAR(250)= NULL,
    @SeatingId UNIQUEIDENTIFIER = NULL,
	@EntityId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
        DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
        
        IF (@HavePermission = '1')
        BEGIN
             IF(@EmployeeId = '00000000-0000-0000-0000-000000000000') SET @EmployeeId = NULL
             
             IF(@SeatCode = '') SET @SeatCode = NULL
             
             IF(@SearchText = '') SET @SearchText = NULL
             
			 IF(@EntityId = '00000000-0000-0000-0000-000000000000') SET @EntityId = NULL

             IF(@Pagesize = 0 OR @Pagesize IS NULL) SET @Pagesize = 2147483640
             
             IF(@Pagenumber IS NULL) SET @Pagenumber = 1
             
             IF(@SortBy IS NULL) SET @SortBy = 'CreatedDateTime'
             
             IF(@SortDirection IS NULL) SET @SortDirection = 'DESC'
             
             SET @SearchText = '%' + RTRIM(LTRIM(@SearchText)) + '%'

			 SET @SeatCode = '%' + RTRIM(LTRIM(@SeatCode)) + '%'
             
             DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
             
             SELECT SA.Id AS SeatingId,
                   SA.EmployeeId,
                   SA.BranchId,
                   B.BranchName,
                   SA.SeatCode,
                   SA.[Description],
                   SA.Comment,
                   U.FirstName,
                   U.SurName,
                   U.FirstName + ' ' + ISNULL(U.SurName,'') AS EmployeeName,
                   U.ProfileImage AS EmployeeProfileImage,
                   SA1.CreatedDateTime,
                   SA.CreatedByUserId,
                   SA.[TimeStamp],
                   CASE WHEN SA.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
                   TotalCount = COUNT(1) OVER()
              FROM [SeatingArrangement] AS SA WITH (NOLOCK)
				   INNER JOIN [SeatingArrangement] SA1 WITH(NOLOCK) ON SA1.Id = SA.Id
                   INNER JOIN [Branch] B WITH (NOLOCK) ON B.Id = SA.BranchId 
							  AND B.CompanyId = @CompanyId
				              AND B.InActiveDateTime IS NULL
							  AND (@EntityId IS NULL OR B.Id IN (SELECT BranchId FROM EntityBranch WHERE EntityId = @EntityId AND InactiveDateTime IS NULL))
                   LEFT JOIN [User] U ON SA.EmployeeId = U.Id AND U.InActiveDateTime IS NULL
             WHERE (@SeatingId IS NULL OR SA.Id = @SeatingId)
                   AND (@BranchId IS NULL OR SA.BranchId = @BranchId)
                   AND (@EmployeeId IS NULL OR SA.EmployeeId = @EmployeeId)
                   AND (@SeatCode IS NULL OR (SA.SeatCode LIKE @SeatCode))
                   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND SA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND SA.InActiveDateTime IS NULL))
                   AND (@SearchText IS NULL OR ((U.FirstName + ' ' + ISNULL(U.SurName,'')) LIKE @SearchText) OR (SA.SeatCode LIKE @SearchText))
             ORDER BY 
                        CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
                              CASE WHEN(@SortBy = 'EmployeeName') THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
                                   WHEN(@SortBy = 'SeatCode') THEN  SA.SeatCode
                                   WHEN @SortBy = 'Description' THEN SA.[Description]
                                   WHEN @SortBy = 'Comment' THEN SA.Comment
                                   WHEN @SortBy = 'BranchName' THEN B.BranchName
                                   WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,SA1.CreatedDateTime,121) AS sql_variant)
                               END
                           END ASC,
                          CASE WHEN @SortDirection = 'DESC' THEN
                              CASE WHEN(@SortBy = 'EmployeeName') THEN U.FirstName + ' ' + ISNULL(U.SurName,'')
                                   WHEN(@SortBy = 'SeatCode') THEN  SA.SeatCode
                                   WHEN @SortBy = 'Description' THEN SA.[Description]
                                   WHEN @SortBy = 'Comment' THEN SA.Comment
                                   WHEN @SortBy = 'BranchName' THEN B.BranchName
                                   WHEN @SortBy = 'CreatedDateTime' THEN CAST(CONVERT(DATETIME,SA1.CreatedDateTime,121) AS sql_variant)
                               END
                          END DESC
                     OFFSET ((@PageNumber - 1) * @PageSize) ROWS
             
             FETCH NEXT @Pagesize ROWS ONLY
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