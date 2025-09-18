using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmployeeWorkExperienceRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmployeeWorkExperience table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmployeeWorkExperienceDbEntity aEmployeeWorkExperience)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeWorkExperience.Id);
					 vParams.Add("@EmployeeId",aEmployeeWorkExperience.EmployeeId);
					 vParams.Add("@Company",aEmployeeWorkExperience.Company);
					 vParams.Add("@DesignationId",aEmployeeWorkExperience.DesignationId);
					 vParams.Add("@FromDate",aEmployeeWorkExperience.FromDate);
					 vParams.Add("@ToDate",aEmployeeWorkExperience.ToDate);
					 vParams.Add("@Comments",aEmployeeWorkExperience.Comments);
					 vParams.Add("@CreatedDateTime",aEmployeeWorkExperience.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeWorkExperience.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeWorkExperience.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeWorkExperience.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeWorkExperienceInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmployeeWorkExperience table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmployeeWorkExperienceDbEntity aEmployeeWorkExperience)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmployeeWorkExperience.Id);
					 vParams.Add("@EmployeeId",aEmployeeWorkExperience.EmployeeId);
					 vParams.Add("@Company",aEmployeeWorkExperience.Company);
					 vParams.Add("@DesignationId",aEmployeeWorkExperience.DesignationId);
					 vParams.Add("@FromDate",aEmployeeWorkExperience.FromDate);
					 vParams.Add("@ToDate",aEmployeeWorkExperience.ToDate);
					 vParams.Add("@Comments",aEmployeeWorkExperience.Comments);
					 vParams.Add("@CreatedDateTime",aEmployeeWorkExperience.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmployeeWorkExperience.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmployeeWorkExperience.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmployeeWorkExperience.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmployeeWorkExperienceUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmployeeWorkExperience table.
		/// </summary>
		public EmployeeWorkExperienceDbEntity GetEmployeeWorkExperience(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmployeeWorkExperienceDbEntity>("USP_EmployeeWorkExperienceSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmployeeWorkExperience table.
		/// </summary>
		 public IEnumerable<EmployeeWorkExperienceDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmployeeWorkExperienceDbEntity>("USP_EmployeeWorkExperienceSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}
		/// <summary>
		/// Selects all records from the EmployeeWorkExperience table by a foreign key.
		/// </summary>
		public List<EmployeeWorkExperienceDbEntity> SelectAllByEmployeeId(Guid employeeId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@EmployeeId",employeeId);
				 return vConn.Query<EmployeeWorkExperienceDbEntity>("USP_EmployeeWorkExperienceSelectAll", vParams, commandType: CommandType.StoredProcedure).ToList();
				 }
		}


	}
}
