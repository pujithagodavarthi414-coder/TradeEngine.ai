using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
	 public partial class QuestionRepository : BaseRepository
	 {

		/// <summary>
		/// Saves a record to the Question table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Insert(QuestionDbEntity aQuestion)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aQuestion.Id);
					 vParams.Add("@CategoryId",aQuestion.CategoryId);
					 vParams.Add("@Question",aQuestion.Question);
					 vParams.Add("@Option1",aQuestion.Option1);
					 vParams.Add("@Option2",aQuestion.Option2);
					 vParams.Add("@Option3",aQuestion.Option3);
					 vParams.Add("@Option4",aQuestion.Option4);
					 vParams.Add("@OptionNo",aQuestion.OptionNo);
					 vParams.Add("@MarksAllocated",aQuestion.MarksAllocated);
					 vParams.Add("@CreatedByUserId",aQuestion.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aQuestion.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aQuestion.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aQuestion.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_QuestionInsert", vParams, commandType: CommandType.StoredProcedure);
			 if (iResult == -1) blResult = true;
			 }
			 return blResult;
		}

		/// <summary>
		/// Updates record to the Question table.
		/// returns True if value saved successfullyelse false
		/// Throw exception with message value 'EXISTS' if the data is duplicate
		/// </summary>
		public bool Update(QuestionDbEntity aQuestion)
		{
		 var blResult = false;
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aQuestion.Id);
					 vParams.Add("@CategoryId",aQuestion.CategoryId);
					 vParams.Add("@Question",aQuestion.Question);
					 vParams.Add("@Option1",aQuestion.Option1);
					 vParams.Add("@Option2",aQuestion.Option2);
					 vParams.Add("@Option3",aQuestion.Option3);
					 vParams.Add("@Option4",aQuestion.Option4);
					 vParams.Add("@OptionNo",aQuestion.OptionNo);
					 vParams.Add("@MarksAllocated",aQuestion.MarksAllocated);
					 vParams.Add("@CreatedByUserId",aQuestion.CreatedByUserId);
					 vParams.Add("@CreatedDateTime",aQuestion.CreatedDateTime);
					 vParams.Add("@UpdatedByUserId",aQuestion.UpdatedByUserId);
					 vParams.Add("@UpdatedDateTime",aQuestion.UpdatedDateTime);
					 int iResult = vConn.Execute("USP_QuestionUpdate", vParams, commandType: CommandType.StoredProcedure);
				 if (iResult == -1) blResult = true;
				 }
			return blResult;
		}

		/// <summary>
		/// Selects the Single object of Question table.
		/// </summary>
		public QuestionDbEntity GetQuestion(Guid aId)
		{
			 using (var vConn = OpenConnection())
				 {
				 var vParams = new DynamicParameters();
					 vParams.Add("@Id",aId);
					 return vConn.Query<QuestionDbEntity>("USP_QuestionSelect", vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
				 }
		}

		/// <summary>
		/// Selects all records from the Question table.
		/// </summary>
		 public IEnumerable<QuestionDbEntity> SelectAll()
		{
			 using (var vConn = OpenConnection())
			{
				 return vConn.Query<QuestionDbEntity>("USP_QuestionSelectAll", commandType: CommandType.StoredProcedure).ToList();
			}
		}

	}
}
