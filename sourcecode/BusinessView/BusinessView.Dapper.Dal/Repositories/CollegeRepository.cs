using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class CollegeRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the College table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(CollegeDbEntity aCollege)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCollege.Id);
					 vParams.Add("@CompanyId",aCollege.CompanyId);
					 vParams.Add("@CoutryId",aCollege.CoutryId);
					 vParams.Add("@StateId",aCollege.StateId);
					 vParams.Add("@CollegeName",aCollege.CollegeName);
					 vParams.Add("@City",aCollege.City);
					 vParams.Add("@CreatedDateTime",aCollege.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCollege.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCollege.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCollege.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CollegeInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the College table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(CollegeDbEntity aCollege)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aCollege.Id);
					 vParams.Add("@CompanyId",aCollege.CompanyId);
					 vParams.Add("@CoutryId",aCollege.CoutryId);
					 vParams.Add("@StateId",aCollege.StateId);
					 vParams.Add("@CollegeName",aCollege.CollegeName);
					 vParams.Add("@City",aCollege.City);
					 vParams.Add("@CreatedDateTime",aCollege.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aCollege.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aCollege.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aCollege.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_CollegeUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of College table.
		/// </summary>
		public CollegeDbEntity GetCollege(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<CollegeDbEntity>("USP_CollegeSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the College table.
		/// </summary>
		 public IEnumerable<CollegeDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<CollegeDbEntity>("USP_CollegeSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
