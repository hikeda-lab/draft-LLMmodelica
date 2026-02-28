= 結果

== RAGシステムの実験

=== 一般的な知識で回答できる問題

熱力学などの高度な知識が必要な問いにも、設計エンジニアが参照できる水準でLLMが回答可能であった。
#ref(<table_SimpleLLMresponse>)にプロンプトと回答を記す。

#figure(
  table(
    columns: 2,
    align: left,
    [prompt], [Explain Helmhetltz Energy Equation.],
    [Answer],
    [#text(size: 6pt)[　`
The Helmholtz free energy F (sometimes written as A) is a thermodynamic potential that measures the maximum useful work obtainable from a closed system at constant temperature and constant volume.
⸻
Definition

F = U - TS

Where:
	•	F or A = Helmholtz free energy [J]
	•	U = Internal energy [J]
	•	T = Absolute temperature [K]
	•	S = Entropy [J/K]
⸻

Physical Meaning
	•	It represents the amount of usable energy in a system that can be converted into work, except for the part lost due to entropy.

.......`]],
  ),
  caption: [Response of LLM],
)<table_SimpleLLMresponse>


=== 文書データベースの情報が回答に必要な質問
関連文書データベースの情報が不可欠な質問にも、RAGを介した回答が可能となった。
#ref(<table_RAGresponse_QA>)にプロンプトと回答を記す。

#figure(
  table(
    columns: 2,
    align: left,
    [prompt],
    [Explain the method of refrigerant property calculation. What is Helmhetltz Energy Equation? Is that related to refrigerant property?],

    [Answer],
    [#text(size: 8pt)[　`
The search results explain different methods for calculating refrigerant properties like density, enthalpy, and temperature based on known state variables like pressure and enthalpy.
 One common approach is to use the chain rule to relate the derivative of density with respect to time to the derivatives of pressure and enthalpy with respect to time (sources 4, 10).

The partial derivatives of density with respect to pressure and enthalpy can be calculated analytically from thermodynamic relations (source 2).,

Source Chnuks
{'text': 'On the other hand, it is wise to     select the enthalpy as the independent state variable because the enthalpy can be     readily used to distinguish whether the refrigerant is in single-phase or two-phase     region and hence appropriate correlations for heat transfer and pressure drop can be     applied accordingly.

......

  2.2.2 Discretization     The partial differential equations (2-1) to (2-3) can be solved by various     methods, like finite difference, finite volume and finite element.'}, 'location': {'s3Location': {'uri': 's3://llmragmerlhvac-hajime-20240909/Qiao_umd_0117E_15712.pdf`]],
  ),
  caption: [Response of LLM],
)<table_RAGresponse_QA>

=== コード作成の指示

ルームエアコン冷凍サイクルモデルの作成をRAGシステムに指示した結果を#ref(<table_RAGresponse>)に示す。
Modelicaに精通した人間であれば、適切なモデルをライブラリから選択し仕様を確認し、空調分野の知識があれば必要な室内機、室外機、圧縮機、膨張弁のモデルを探し、部屋モデルも含めて動的挙動を再現できるが、LLM単体では「I don't know.」と応答するに留まった。
ただしRAGシステムは関連モデルを検索結果として提示できている。

\
#ref(<table_RAGresponse>)の出力には、LLMの回答だけでなく、回答の根拠となる検索結果（Source Chunks）を表示している。
LLMの回答は、'I don't konw.'のみであった。
Source Chnunksによると、RAGシステムは、ルームエアコンに関連するモデルのいくつかは検索結果として取得しているが、その上で無回答を検索している。

#figure(
  table(
    columns: 2,
    align: left,
    [prompt], [Construct room air conditioner model by MERL-HVAC Library.],
    [Answer],
    [I don't know.
      `
Source Chunks:
  - VCComponents\Components\AirHandling\Testing\MultiportLumpedRoomTest.mo-0
  - VCComponents\Components\AirHandling\FanCurveModels\package.mo-0
  - VCComponents\Components\AirHandling\FanCurveModels\BaseClasses\package.mo-0
  - MEBuildings\USDOE\SmallOffice\FullMode\FourZoneOffice.mo0`],
  ),
  caption: [Response of LLM],
)<table_RAGresponse>


== Ｍｏｄｅｌｉｃａコード生成エージェントの実験

RAGシステムでは対応できなかったコーディング作業についても、エージェント型ワークフローを導入することで、Plannerエージェントが実行環境構築やパラメータ設定、モデル接続、制御ロジック実装などの手順を具体的に提示した。
#ref(<table_PlannerResponse>)にエージェントワークフローのPlannerエージェントの出力を載せる。

Planenrは、前段階のRAGエージェントから検索結果を受け取り、ルームエアコンのモデル作成にVCComponentsというモデルが関連することを受け取っている。その上で、Modelicaの実況環境の構築（'1 Set Up the Environment'）やシミュレーションに幾つかのパラメータ設定が必要なことを確認している('3 Define Parameters')。
また、'11 Validation:'では、プロンプトの指示外ではあるが、シミュレーション結果の検証を計画した。

#figure(
  table(
    columns: 1,
    align: left,
    [#text(size: 7pt)[
        `
1 Set Up the Environment:
  • Ensure you have a Modelica environment installed (e-g-, OpenModelica, Dymola).
  • Import the MERL-IVAC Library (VCComponents) into your Modelica environment.
2 Create a New Model:
  • Start a new Modelica model file (e-f•, RoomAirConditioner-mo).
  • Define the model structure and include necessary libraries. within YourPackageName; model RoomAirConditioner
3 Define Parameters:
  • Define parameters for the room conditions, such as temperature, humidity, and volume. You can use the parameters from the MultiportLumpedRoomTest model as a reference.
  parameter SI. Temperature TRoom_init - Modelica. Units. Conversions. from_degC(27.0);
  parameter Real RHRoom_init = 0.51;
  parameter SI. Volume volRoom = 87.5 * 77 * 84 * 1.63871e-5 * 10;
4 Instantiate the Room Model:
  • Use the MultiportLumpedRoomTest model to represent the room. This model will handle the thermal dynamics of the room.
MultiportLumpedRoomTest room(TRoom_init TRoom_ init, RHRoom_ init-RHRoom init, volRoom-volRoom);
5 Define the Air Handling System:
  • Create an air handling system using components from the FanCurveModels package. You may need to define a fan and a cooling coil.
    // Example of instantiating a fan and cooling coil
    FanCurveModels. Fan fan(...);
    CoolingCoil coolingCoil(...);
6 Connect Components:
  • Connect the room,fan, and cooling coil. Ensure that the air flow from the fan goes into the room and that the cooling coil is properly integrated into the air handling system.connect (fan.outlet, coolingCoil. inlet); connect (coolingCoil.outlet, room.airinlet);
7 Define Control Logic:
  • Implement control logic for the air conditioner. This could involve setting temperature setpoints and controlling the fan speed based on room conditions.
  // Example control logic
  if room. TRoom > TRoom setpoint then
  fan. speed = maxFanSpeed; // Turn on the fan
  else
    fan. speed = 0; // Turn off the fan
  end if;
8 Add HVAC System Record:
  • Optionally, you can include the HVACSystem record to manage the operating conditions of the HVAC system.
HVACSystem hvacSystem(...);
9 Simulation Setup:
  • Set up the simulation parameters, including the simulation time and solver settings.
simulate(RoomAirConditioner);
10 Run the Simulation:
  • Execute the simulation and analyze the results, Check the room temperature, humidity, and other relevant outputs to ensure the air conditioner is functioning as expected.
11 Validation:
  • Validate the model against known benchmarks or existing models (e-g-, EnergyPlus) to ensure accuracy.
12 Documentation:
  • Document the model, including the purpose, parameters, and any assumptions made during the modeling process,
13.Conclusion
  By following these steps, you can construct a room air conditioner model using the MERL-HVAC Library (VCComponents). Adjust the parameters and components as necessary to fit your specific requirements and ensure the

      `]
    ],
  ),
  caption: [Response of Planner agent],
)<table_PlannerResponse>


#ref(<table_codegeneration_response>)にCode Generationエージェントの出力を載せる。
実際にはエージェントの出力したコードはそのままでは、コンパイルが通らない。モデルの完成にはパラメータ値の設定が必要になる。ただし、選択したコンポーネントには間違いはなく、モデル作成の初期段階の作業支援の結果としては十分である。
Code GenerationエージェントがModelicaコードの雛形を自動生成できることを確認した。
これにより、従来専門知識が必要だったモデル構築作業の自動化・省力化が可能となった。



#figure(
  table(
    columns: 1,
    align: left,

    [#text(size: 7pt)[`

within YourPackageName;

model RoomAirConditioner

// Import necessary libraries
import Modelica. SIunits;
import VCComponents.Components.AirHandling.Testing.MultiportLumpedRoomTest;
import VCComponents.Components.AirHandling.FanCurveModels;
import MEBuildings.USDOE.ResidentialPrototype.BaseClasses.RecordTemplates.OperatingConditions.HVACSystem;

// Define parameters for the room conditions
parameter SI. Temperature TRoom_init = Modelica. Units.Conversions. from _degC(27.0);
parameter Real RHRoom_init = 0.51;
parameter SI. Volume volRoom = 87.5 * 77 * 84 * 1.63871e-5 * 10;

// Instantiate the room model
MultiportLumpedRoomTest room(
    TRoom_init-TRoom_ init,
    RHRoom_init=RHRoom_init,
    volRoom=volRoom);

// Define the air handling system components
FanCurveModels. Fan fan(
    // Define fan parameters here
    // Example: flowRate=..., pressureRise=..., etc.
);

CoolingCoil coolingCoil(
    // Define cooling coil parameters here
    // Example: coolingCapacity=..., etc.
);

// Connect components
connect(fan.outlet, coolingCoil. inlet);
connect (coolingCoil. outlet, room.airInlet);

// Define control logic
parameter SI. Temperature TRoom setpoint = Modelica. Units. Conversions. from_degC(24.0);
parameter Real maxFanSpeed = 1.0; // Maximum fan speed

// Control logic for the air conditioner
equation
    if room. TRoom > TRoom_setpoint then
        fan. speed = maxFanSpeed; // Turn on the fan
    else
        fan. speed = 0; // Turn off the fan
    end if;

// Optionally, include the HVAC system record

HVACSystem hvacSystem(
    // Define HVAC system parameters here
    // Example: eps=..., TAirSupply=..., etc.
);

end RoomAirConditioner;

    `]],
  ),
  caption: [Response of Code generation agent.],
)<table_codegeneration_response>
