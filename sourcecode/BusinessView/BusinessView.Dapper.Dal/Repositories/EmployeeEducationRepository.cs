using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeEducationRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeEducation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeEducationDbEntity aEmployeeEducation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeEducation.Id);
					 vParams.Add("@EmployeeId",aEmployeeEducation.EmployeeId);
					 vParams.Add("@EducationLevelId",aEmployeeEducation.EducationLevelId);
					 vParams.Add("@Institute",aEmployeeEducation.Institute);
					 vParams.Add("@MajorSpecilalization",aEmployeeEducation.MajorSpecilalization);
					 vParams.Add("@GPA_Score",aEmployeeEducation.GPA_Score);
					 vParams.Add("@StartDate",aEmployeeEducation.StartDate);
					 vParams.Add("@EndDate",aEmployeeEducation.EndDate);
					 vParams.Add("@CreatedDateTime",aEmployeeEducation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeEducation.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeEducation.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeEducation.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeEducationInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeEducation table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeEducationDbEntity aEmployeeEducation)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeEducation.Id);
					 vParams.Add("@EmployeeId",aEmployeeEducation.EmployeeId);
					 vParams.Add("@EducationLevelId",aEmployeeEducation.EducationLevelId);
					 vParams.Add("@Institute",aEmployeeEducation.Institute);
					 vParams.Add("@MajorSpecilalization",aEmployeeEducation.MajorSpecilalization);
					 vParams.Add("@GPA_Score",aEmployeeEducation.GPA_Score);
					 vParams.Add("@StartDate",aEmployeeEducation.StartDate);
					 vParams.Add("@EndDate",aEmployeeEducation.EndDate);
					 vParams.Add("@CreatedDateTime",aEmployeeEducation.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeEducation.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeEducation.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeEducation.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeEducationUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeEducation table.
		/// </summary>
		public EmployeeEducationDbEntity GetEmployeeEducation(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeEducationDbEntity>("USP_EmployeeEducationSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeEducation table.
		/// </summary>
		 public IEnumerable<EmployeeEducationDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeEducationDbEntity>("USP_EmployeeEducationSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeEducation table by a foreign key.
		/// </summary>
		public List<EmployeeEducationDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeEducationDbEntity>("USP_EmployeeEducationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeEducation table by a foreign key.
		/// </summary>
		public List<EmployeeEducationDbEntity> SelectAllByEducationLevelId(Guid educationLevelId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EducationLevelId",educationLevelId);
				 return vConn.Query<EmployeeEducationDbEntity>("USP_EmployeeEducationSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
