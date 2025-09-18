using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class TagRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Tag table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(TagDbEntity aTag)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTag.Id);
					 vParams.Add("@GoalTagId",aTag.GoalTagId);
					 vParams.Add("@UserStoryTagId",aTag.UserStoryTagId);
					 vParams.Add("@CreatedDateTime",aTag.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTag.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTag.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTag.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TagInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Tag table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(TagDbEntity aTag)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aTag.Id);
					 vParams.Add("@GoalTagId",aTag.GoalTagId);
					 vParams.Add("@UserStoryTagId",aTag.UserStoryTagId);
					 vParams.Add("@CreatedDateTime",aTag.CreatedDateTime);
					 vParams.Add("@CreatedByUserId",aTag.CreatedByUserId);
					 vParams.Add("@UpdatedDateTime",aTag.UpdatedDateTime);
					 vParams.Add("@UpdatedByUserId",aTag.UpdatedByUserId);
					 int iResult = vConn.Execute("USP_TagUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Tag table.
		/// </summary>
		public TagDbEntity GetTag(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<TagDbEntity>("USP_TagSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Tag table.
		/// </summary>
		 public IEnumerable<TagDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<TagDbEntity>("USP_TagSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
