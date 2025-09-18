using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class EmploymentStatuRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the EmploymentStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(EmploymentStatuDbEntity aEmploymentStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmploymentStatu.Id);
					 vParams.Add("@CompanyId",aEmploymentStatu.CompanyId);
					 vParams.Add("@EmploymentStatus",aEmploymentStatu.EmploymentStatus);
					 vParams.Add("@CreatedDateTime",aEmploymentStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmploymentStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmploymentStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmploymentStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmploymentStatusInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the EmploymentStatus table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(EmploymentStatuDbEntity aEmploymentStatu)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aEmploymentStatu.Id);
					 vParams.Add("@CompanyId",aEmploymentStatu.CompanyId);
					 vParams.Add("@EmploymentStatus",aEmploymentStatu.EmploymentStatus);
					 vParams.Add("@CreatedDateTime",aEmploymentStatu.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aEmploymentStatu.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aEmploymentStatu.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aEmploymentStatu.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_EmploymentStatusUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of EmploymentStatus table.
		/// </summary>
		public EmploymentStatuDbEntity GetEmploymentStatu(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<EmploymentStatuDbEntity>("USP_EmploymentStatusSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the EmploymentStatus table.
		/// </summary>
		 public IEnumerable<EmploymentStatuDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<EmploymentStatuDbEntity>("USP_EmploymentStatusSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
