﻿//------------------------------------------------------------------------------
//  <auto-generated>
//     This code was generated by a tool.
//     Runtime version: 4.0.30319.42000
//     Generator      : XSharp.CodeDomProvider 2.8.0.0
//     Timestamp      : 15/09/2021 14:09:57
//     
//     Changes to this file may cause incorrect behavior and may be lost if
//     the code is regenerated.
//  </auto-generated>
//------------------------------------------------------------------------------
BEGIN NAMESPACE XanthiServerTest

    PUBLIC PARTIAL CLASS MainWindow
        PRIVATE groupBox1 AS System.Windows.Forms.GroupBox
        PRIVATE portNumber AS System.Windows.Forms.NumericUpDown
        PRIVATE label2 AS System.Windows.Forms.Label
        PRIVATE label1 AS System.Windows.Forms.Label
        PRIVATE comboIPList AS System.Windows.Forms.ComboBox
        PRIVATE listBoxClients AS System.Windows.Forms.ListBox
        PRIVATE buttonStop AS System.Windows.Forms.Button
        PRIVATE buttonStart AS System.Windows.Forms.Button
        PRIVATE listBoxMessages AS System.Windows.Forms.ListBox
        PRIVATE components := NULL AS System.ComponentModel.IContainer

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        PROTECTED METHOD Dispose(disposing AS LOGIC) AS VOID  STRICT

            IF (disposing .AND. (components != null))
                components:Dispose()
            ENDIF
            SUPER:Dispose(disposing)
   RETURN

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        PRIVATE METHOD InitializeComponent() AS VOID STRICT
            SELF:groupBox1 := System.Windows.Forms.GroupBox{}
            SELF:buttonStop := System.Windows.Forms.Button{}
            SELF:buttonStart := System.Windows.Forms.Button{}
            SELF:portNumber := System.Windows.Forms.NumericUpDown{}
            SELF:label2 := System.Windows.Forms.Label{}
            SELF:label1 := System.Windows.Forms.Label{}
            SELF:comboIPList := System.Windows.Forms.ComboBox{}
            SELF:listBoxClients := System.Windows.Forms.ListBox{}
            SELF:listBoxMessages := System.Windows.Forms.ListBox{}
            SELF:groupBox1:SuspendLayout()
            ((System.ComponentModel.ISupportInitialize)(SELF:portNumber)):BeginInit()
            SELF:SuspendLayout()
            // 
            // groupBox1
            // 
            SELF:groupBox1:Controls:Add(SELF:buttonStop)
            SELF:groupBox1:Controls:Add(SELF:buttonStart)
            SELF:groupBox1:Controls:Add(SELF:portNumber)
            SELF:groupBox1:Controls:Add(SELF:label2)
            SELF:groupBox1:Controls:Add(SELF:label1)
            SELF:groupBox1:Controls:Add(SELF:comboIPList)
            SELF:groupBox1:Location := System.Drawing.Point{12, 12}
            SELF:groupBox1:Name := "groupBox1"
            SELF:groupBox1:Size := System.Drawing.Size{511, 59}
            SELF:groupBox1:TabIndex := 1
            SELF:groupBox1:TabStop := false
            SELF:groupBox1:Text := "Server Info"
            // 
            // buttonStop
            // 
            SELF:buttonStop:Location := System.Drawing.Point{423, 21}
            SELF:buttonStop:Name := "buttonStop"
            SELF:buttonStop:Size := System.Drawing.Size{75, 28}
            SELF:buttonStop:TabIndex := 3
            SELF:buttonStop:Text := "Stop"
            SELF:buttonStop:UseVisualStyleBackColor := true
            SELF:buttonStop:Visible := false
            SELF:buttonStop:Click += System.EventHandler{ SELF, @buttonStop_Click() }
            // 
            // buttonStart
            // 
            SELF:buttonStart:Location := System.Drawing.Point{423, 21}
            SELF:buttonStart:Name := "buttonStart"
            SELF:buttonStart:Size := System.Drawing.Size{75, 28}
            SELF:buttonStart:TabIndex := 5
            SELF:buttonStart:Text := "Start"
            SELF:buttonStart:UseVisualStyleBackColor := true
            SELF:buttonStart:Click += System.EventHandler{ SELF, @buttonStart_Click() }
            // 
            // portNumber
            // 
            SELF:portNumber:Location := System.Drawing.Point{342, 22}
            SELF:portNumber:Maximum := DECIMAL{<INT>{ 65535, 0, 0, 0 }}
            SELF:portNumber:Name := "portNumber"
            SELF:portNumber:Size := System.Drawing.Size{71, 22}
            SELF:portNumber:TabIndex := 4
            // 
            // label2
            // 
            SELF:label2:AutoSize := true
            SELF:label2:Location := System.Drawing.Point{294, 24}
            SELF:label2:Name := "label2"
            SELF:label2:Size := System.Drawing.Size{42, 17}
            SELF:label2:TabIndex := 2
            SELF:label2:Text := "Port :"
            // 
            // label1
            // 
            SELF:label1:AutoSize := true
            SELF:label1:Location := System.Drawing.Point{13, 24}
            SELF:label1:Name := "label1"
            SELF:label1:Size := System.Drawing.Size{28, 17}
            SELF:label1:TabIndex := 1
            SELF:label1:Text := "IP :"
            // 
            // comboIPList
            // 
            SELF:comboIPList:DropDownStyle := System.Windows.Forms.ComboBoxStyle.DropDownList
            SELF:comboIPList:FormattingEnabled := true
            SELF:comboIPList:Location := System.Drawing.Point{46, 21}
            SELF:comboIPList:Name := "comboIPList"
            SELF:comboIPList:Size := System.Drawing.Size{235, 24}
            SELF:comboIPList:TabIndex := 0
            // 
            // listBoxClients
            // 
            SELF:listBoxClients:FormattingEnabled := true
            SELF:listBoxClients:ItemHeight := 16
            SELF:listBoxClients:Location := System.Drawing.Point{12, 87}
            SELF:listBoxClients:Name := "listBoxClients"
            SELF:listBoxClients:Size := System.Drawing.Size{214, 212}
            SELF:listBoxClients:TabIndex := 2
            // 
            // listBoxMessages
            // 
            SELF:listBoxMessages:FormattingEnabled := true
            SELF:listBoxMessages:ItemHeight := 16
            SELF:listBoxMessages:Location := System.Drawing.Point{244, 87}
            SELF:listBoxMessages:Name := "listBoxMessages"
            SELF:listBoxMessages:Size := System.Drawing.Size{279, 212}
            SELF:listBoxMessages:TabIndex := 3
            // 
            // MainWindow
            // 
            SELF:AutoScaleDimensions := System.Drawing.SizeF{8, 16}
            SELF:AutoScaleMode := System.Windows.Forms.AutoScaleMode.Font
            SELF:ClientSize := System.Drawing.Size{543, 364}
            SELF:Controls:Add(SELF:listBoxMessages)
            SELF:Controls:Add(SELF:listBoxClients)
            SELF:Controls:Add(SELF:groupBox1)
            SELF:MaximizeBox := false
            SELF:MinimizeBox := false
            SELF:Name := "MainWindow"
            SELF:Text := "Xanthi Server"
            SELF:FormClosing += System.Windows.Forms.FormClosingEventHandler{ SELF, @MainWindow_FormClosing() }
            SELF:Load += System.EventHandler{ SELF, @MainWindow_Load() }
            SELF:groupBox1:ResumeLayout(false)
            SELF:groupBox1:PerformLayout()
            ((System.ComponentModel.ISupportInitialize)(SELF:portNumber)):EndInit()
            SELF:ResumeLayout(false)

        #endregion
    END CLASS 
END NAMESPACE
