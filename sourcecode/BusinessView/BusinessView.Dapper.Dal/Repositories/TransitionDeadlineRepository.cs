using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal;
using BTrak.Dapper.Dal.Models;
using BusinessView.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TransitionDeadlineRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the TransitionDeadline table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TransitionDeadlineDbEntity aTransitionDeadline)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTransitionDeadline.Id);
					 vParams.Add("@Deadline",aTransitionDeadline.Deadline);
					 vParams.Add("@CompanyId",aTransitionDeadline.CompanyId);
					 vParams.Add("@CreatedDateTime",aTransitionDeadline.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTransitionDeadline.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTransitionDeadline.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTransitionDeadline.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TransitionDeadlineInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the TransitionDeadline table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TransitionDeadlineDbEntity aTransitionDeadline)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTransitionDeadline.Id);
					 vParams.Add("@Deadline",aTransitionDeadline.Deadline);
					 vParams.Add("@CompanyId",aTransitionDeadline.CompanyId);
					 vParams.Add("@CreatedDateTime",aTransitionDeadline.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTransitionDeadline.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTransitionDeadline.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTransitionDeadline.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TransitionDeadlineUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of TransitionDeadline table.
		/// </summary>
		public TransitionDeadlineDbEntity GetTransitionDeadline(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TransitionDeadlineDbEntity>("USP_TransitionDeadlineSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the TransitionDeadline table.
		/// </summary>
		 public IEnumerable<TransitionDeadlineDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TransitionDeadlineDbEntity>("USP_TransitionDeadlineSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
