using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CompanyRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Company table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CompanyDbEntity aCompany)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCompany.Id);
					 vParams.Add("@CompanyName",aCompany.CompanyName);
					 vParams.Add("@CreatedDateTime",aCompany.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCompany.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCompany.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCompany.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CompanyInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Company table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CompanyDbEntity aCompany)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCompany.Id);
					 vParams.Add("@CompanyName",aCompany.CompanyName);
					 vParams.Add("@CreatedDateTime",aCompany.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCompany.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCompany.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCompany.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CompanyUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Company table.
		/// </summary>
		public CompanyDbEntity GetCompany(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CompanyDbEntity>("USP_CompanySelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Company table.
		/// </summary>
		 public IEnumerable<CompanyDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CompanyDbEntity>("USP_CompanySelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
