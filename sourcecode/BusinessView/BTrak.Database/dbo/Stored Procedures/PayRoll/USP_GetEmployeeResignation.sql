CREATE PROCEDURE [dbo].[USP_GetEmployeeResignation]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@SearchText NVARCHAR(500) = NULL,
	@IsArchived BIT= NULL,
	@ResignationStatusId UNIQUEIDENTIFIER = NULL,
	@EmployeeResignationId UNIQUEIDENTIFIER = NULL,
	@EmployeeId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		IF (@HavePermission = '1')
	    BEGIN
		   IF(@SearchText  = '') SET @SearchText  = NULL
		   SET @SearchText = '%'+ @SearchText +'%'
		   IF(@ResignationStatusId = '00000000-0000-0000-0000-000000000000') SET @ResignationStatusId = NULL	
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
           SELECT ER.Id AS EmployeeResignationId,
				  ER.EmployeeId,
				  ER.ResginationApprovedByEmployeeId AS ResignationApprovedById,
				  RS.Id AS ResignationStatusId,
				  ER.ResignationDate,
				  ER.LastDate,
				  ER.ApprovedDate,
				  ER.RejectedDate,
		   	      ER.InActiveDateTime,
		   	      ER.CreatedDateTime,
		   	      ER.CreatedByUserId,
		   	      ER.[TimeStamp],
				  	EMP.EmployeeNumber,  
				  (CASE WHEN ER.InActiveDateTime IS NULL THEN 0 ELSE 1 END) As IsArchived,
				  U.FirstName + ' ' +U.SurName AS EmployeeFullName,
				  U.ProfileImage,
				  U.Id AS UserId,
				  User1.FirstName + ' ' +User1.SurName AS ResignationApprovedByFullName,
				  User2.FirstName + ' ' +User2.SurName AS ResignationRejectedByFullName,
				  RS.StatusName,
				  RS.IsApproved,
				  RS.IsWaitingForApproval,
				  RS.IsRejected,
				  ER.CommentByEmployee,
				  ER.CommentByEmployer,
				  RS.ResignationStatusColour,
				  TotalCount = COUNT(1) OVER()
           FROM EmployeeResignation AS ER
		   INNER JOIN Employee EMP ON EMP.Id = ER.EmployeeId
		   INNER JOIN [User] U ON U.Id = EMP.UserId
		   LEFT JOIN Employee EMP1 ON EMP1.Id =ER.ResginationApprovedByEmployeeId
		   LEFT JOIN [User] User1 ON User1.Id= EMP1.UserId
		   LEFT JOIN Employee EMP2 ON EMP2.Id =ER.ResginationRejectedByEmployeeId
		   LEFT JOIN [User] User2 ON User2.Id= EMP2.UserId
		   LEFT JOIN ResignationStatus RS ON RS.Id = ER.ResignationStastusId
           WHERE ((@EmployeeId IS NULL OR EMP.Id = @EmployeeId)
		        AND (U.CompanyId = @CompanyId)
				AND (@EmployeeResignationId IS NULL OR ER.Id = @EmployeeResignationId)
				AND (@IsArchived IS NULL
				     OR (@IsArchived = 1 AND ER.InActiveDateTime IS NOT NULL)
					 OR (@IsArchived = 0 AND ER.InActiveDateTime IS NULL)))
           ORDER BY U.FirstName ASC
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