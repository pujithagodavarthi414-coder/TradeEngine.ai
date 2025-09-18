--SELECT * FROM [Ufn_GetEmployeeReportedMembers_New] ('23556CF7-4A07-4C7A-A92E-2038B0D5579C','AB38CC2A-E237-430D-9154-DB264E08DD31')

CREATE FUNCTION [dbo].[Ufn_GetEmployeeReportedMembers_New]
(
  @TeamLeadId UNIQUEIDENTIFIER,
  @CompanyId UNIQUEIDENTIFIER
)
RETURNS @ret TABLE
(
   ParentId UNIQUEIDENTIFIER,
   ChildId UNIQUEIDENTIFIER INDEX IX_Child Clustered
)

BEGIN
    IF(@TeamLeadId = '00000000-0000-0000-0000-000000000000') 
	
	SET @TeamLeadId = NULL

    DECLARE @GetParent UNIQUEIDENTIFIER

    SELECT @GetParent = E.Id FROM Employee E 
    JOIN [User] U ON U.Id = E.UserId 
    WHERE U.Id = @TeamLeadId
        AND E.InActiveDateTime IS NULL

		
     
     IF(@TeamLeadId IS NOT NULL)
     BEGIN
         
		 	 DECLARE @AllFeatureId UNIQUEIDENTIFIER = (SELECT FeatureId
                                                    FROM CompanyModule CM 
                                                         INNER JOIN FeatureModule FM ON CM.ModuleId = FM.ModuleId AND FM.InActiveDateTime IS NULL AND CM.InActiveDateTime IS NULL  AND CM.CompanyId = @CompanyId
                                                         INNER JOIN Feature F ON F.Id = FM.FeatureId WHERE F.Id = 'D7733403-BD9F-42E3-B9C2-36CC9F69804E' --Manage app filters
												 GROUP BY FeatureId)

				  DECLARE @IsHaveAllpermission BIT =(CASE WHEN  EXISTS(SELECT 1 FROM [RoleFeature] WHERE RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@TeamLeadId)) AND FeatureId = @AllFeatureId AND InActiveDateTime IS NULL) THEN 1 ELSE 0 END)
         
		 IF(@IsHaveAllpermission = 0)
		 BEGIN

		 INSERT INTO @ret VALUES(@GetParent,@GetParent)
         
        INSERT INTO @ret ( ParentId, ChildId)
		SELECT   ReportToEmployeeId, EmployeeId
		FROM EmployeeReportTo ER
		JOIN Employee E ON E.Id = ER.EmployeeId AND ER.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
		JOIN [User] U ON U.Id = E.UserId AND U.CompanyId = @CompanyId AND U.InActiveDateTime IS NULL AND ER.ReportToEmployeeId = @GetParent
		WHERE (CONVERT(DATE,ActiveFrom) < GETDATE()) AND (ActiveTo IS NULL OR (CONVERT(DATE,ActiveTo) > GETDATE()))
      
      
	   END
	   ELSE
	   BEGIN

	    INSERT INTO @ret VALUES(@GetParent,@GetParent)
         
       INSERT INTO @ret ( ParentId, ChildId)
		SELECT   ReportToEmployeeId, EmployeeId
		FROM EmployeeReportTo ER
		JOIN Employee E ON E.Id = ER.EmployeeId AND ER.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
		JOIN [User] U ON U.Id = E.UserId AND U.CompanyId = @CompanyId AND U.InActiveDateTime IS NULL
		WHERE (CONVERT(DATE,ActiveFrom) < GETDATE()) AND (ActiveTo IS NULL OR (CONVERT(DATE,ActiveTo) > GETDATE()))
                         
	   END

	    UPDATE @ret SET ParentId = E.UserId 
	   FROM @ret 
	   JOIN [Employee] E ON ParentId = E.Id AND E.InActiveDateTime IS NULL

	   UPDATE @ret SET ChildId = E.UserId 
	   FROM @ret 
	   JOIN [Employee] E ON ChildId = E.Id AND E.InActiveDateTime IS NULL
	   

END
RETURN     

                                                                                                                               
END