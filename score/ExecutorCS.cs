using Godot;
using System;
using System.Data;
using Npgsql;
public class ExecutorCS : Node
{

    private bool conectionOpen = false;

    static string Server = "Server=babar.db.elephantsql.com ";
    static string User = "User Id=kasaqgit";
    static string DB = "Database=kasaqgit";
    static string Password = "Password=VkRo0H46qOpYUsakGojUN0cJVAMRfKnR";

    NpgsqlConnection Connection = new NpgsqlConnection(Server + ";" + User + ";" + Password + ";" + DB);
    public void Start()
    {
        Connection.Open();
        conectionOpen = true;
    }

    public void registrarJogador(string Nome, int Pontuacao) {
        int tamanhoTabela = 0;
        string scrptTamanhoTabela = "SELECT COUNT(score) FROM highscore";
        NpgsqlCommand comandoTamanhoTabela = new NpgsqlCommand(scrptTamanhoTabela, Connection);
        tamanhoTabela = Convert.ToInt32(comandoTamanhoTabela.ExecuteScalar());
        if (tamanhoTabela > 10)
        {
            string scrptMenorPontuacao = "SELECT id FROM highscore ORDER BY score ASC LIMIT 1";
            NpgsqlCommand comandoMenorPontuacao = new NpgsqlCommand(scrptMenorPontuacao, Connection);
            string Id = comandoMenorPontuacao.ExecuteScalar().ToString();

            string atualizarRegistro = String.Format("UPDATE highscore SET nome = '{0}',score = {1}, WHERE id = '{2}'", Nome, Pontuacao, Id);
            NpgsqlCommand comandoAtualizar = new NpgsqlCommand(atualizarRegistro, Connection);
            comandoAtualizar.ExecuteNonQuery();

        }
        else
        {
            string inserirRegistro = String.Format("INSERT INTO highscore (nome, score) VALUES ('{0}', {1})", Nome, Pontuacao);
            NpgsqlCommand comandoInserir = new NpgsqlCommand(inserirRegistro, Connection);
            comandoInserir.ExecuteNonQuery();
        }
    }
    public void retornarJogadores()
    {
        string scrptRetornarRegistros = "SELECT * FROM highscore ORDER BY score DESC";
        NpgsqlDataAdapter dataAdapter = new NpgsqlDataAdapter(scrptRetornarRegistros, Connection);

        DataSet dataSet = new DataSet();
        dataAdapter.Fill(dataSet);
        DataTable highscore = dataSet.Tables[0];

        foreach (DataRow row in highscore.Rows)
        {
            GetParent().CallDeferred("receberJogador", row[1].ToString(), row[2].ToString());
        }

    }
    public override void _ExitTree()
    {


        if (conectionOpen)
        {
            Connection.Close();
        }
    }

}
