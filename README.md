# FrameworkStruct
iOS App基础架构设计

# 开发中...

## 概述
目前，各种项目并没有良好的管理，通常是随着开发人员的个人喜好进行开发。项目中目录结构混乱，代码质量良莠不齐，没有良好的组件化管理，导致代码修改困难，冗余代码量大，没有统一的规范化管理。在项目初期可能还不明显，但是项目规模扩大到一定程度，迭代了多个版本之后，弊端就越来越明显。很多代码牵一发动全身，修改一处导致多处产生bug，不利于扩展，费时费力，事倍功半。相信很多大公司都会有自己的解决方案，不过也许并没有很好的通用性，并且那也是商业机密，一般公司也无法获取。隐藏，我根据多年来自己项目开发的经验，设计了这一套通用的iOS开发模板。

## 目标
该项目根据我自己的工程理念设计了一套通用的iOS项目开发模板，目标是期望作为任何一个iOS项目的底层框架模板。任何想要开发iOS App的人都可以从这个项目出发，进行简单的配置就可以开发出自己的App，摒弃繁琐的开发设置，专注于自己的业务内容，快速开发App；提供了一组常用工具集，让开发更简单，更加组件化和模块化；并提供了简单的扩展方法，让新功能和第三方组件更容易扩展和接入。

## 主要内容
### 功能分层
对整个项目的功能进行分层和功能分类。主要分为数据层、业务逻辑层、显示层。数据层包括数据源（数据库、本地沙盒、配置文件、钥匙串等）、数据存取器（对数据源进行存取操作）、数据容器（在内存中存放数据的仓库）、数据校验器（根据需求对数据完整性进行校验）等。业务逻辑层包括监控器、管理器、适配器、修饰器、工作者等，主要管理业务逻辑和各种组件。显示层就是UI，用来展示数据和接受用户操作，主要包括视图控制器等，当然也应该支持控制台应用（这是远景规划）。

### 结构化的模板
该项目根据开发实践设计了一套代码模板，规范了文件夹结构，为项目中需要用到的各个组件都做了定义，并规定了应该存在的位置，当想要开发一个新功能时，开发人员能明确地知道该功能应该在何处，作为何种组件进行开发。增强其模块化开发的思想，降低代码的耦合性。

### 明确的功能分类
对项目中的各个组件都做了分类和定义，几乎包括了所有开发中可能用到的组件类型，做了规范化定义。有未包含的组件和功能也可以很快找到其定位和分类，确保每一个组件都分门别类放好。比如监控器、管理器、适配器、数据容器、数据存取器等，对各种专门的功能都进行了特化，每一个组件专注于自己的领域内，互相之间进行调用来扩展功能。如果有新的功能类别出现，也可以很容易地进行扩展。对于一些系统组件，也对其扩展功能进行了定义并明确了位置，方便未来扩展更多的功能。

### 实时可用性
项目中的预定义组件多是单例，也是全局可用的。理论上，可以从最根部的监控器获取到项目中所有活跃的组件和对象。当然这样比较麻烦。因此，在每一级特定的组件上，都会对其所管理的功能提供简化方法。这些方法都可在全局范围内随时可用。当然，它们仍然保持了模块化的特性。能够快速定位所属位置并知道如何使用。

### 代码设计
该项目预定义了一些规范化的代码设计内容。包括代码规范、代码结构、开发方式等。大部分组件有着统一的代码结构，定义了一个类中为不同使用场景设计的接口方法。比如，内部类型、供外部程序调用的方法、内部方法、代理和通知方法等。对这些内容进行了分类，并写在不同的代码块中，而不是像以前一样全部挤在一起，分不清哪些方法是用来做什么用的。

### 丰富的组件和功能
该项目提供了大量的预定义组件和功能，比如网络访问、系统通知、数据库支持、主题管理、沙盒访问、下载上传、WebView支持、Toast、弹框、弹窗、多线程管理、定时器管理等等。覆盖了一般开发中常用的功能和组件。提供了方便的方法，使用简单、一目了然。

### 方便扩展
该项目对各种内容都做了定义，就是为了方便扩展和模块化开发。毕竟一个项目不能照顾到所有的内容，因此需要对扩展提供良好的支持。开发人员在熟练使用该项目的功能并理解其设计理念后，可以很方便地对功能进行扩展，包括系统组件扩展、第三方组件扩展、自定义组件扩展等。

### 良好的注释和使用习惯
该项目中的所有功能都有良好的注释，任何人都能快速掌握其使用方法。并且也做了规范化的例子，方便开发人员按照这个规范继续开发下去。保证代码的一致性和统一性。

### 非侵入式
该项目中的所有模块和功能都是非侵入式的，开发人员如果不想按照模板的设计进行开发也可以，使用自己习惯的方式进行开发。该项目并不强迫开发人员一定要采用某种模式。但是这样就失去了该项目的意义，完全可以放弃这个项目使用自己的开发方式。

### 持续开发
该项目并没有最终节点，可以根据实际需要持续开发下去，不断扩展新的功能和组件，当然也可以删除不必要的组件。还可以对项目结构进行持续调整和优化。

## 设计理念
### 关于宇宙和世界
从古至今，人类对宇宙就有无穷的想象，流传下来了大量的神话故事。对于那些未知的自然现象都冠以神的名义，甚至这个宇宙、这个世界也是神所创造的。神是世界上的第一束光芒，是宇宙的起源。然后从主神中诞生出了各种各样管理各种专门事务的神祇。我个人比较喜欢希腊神话，除去神祇之间混乱的男女关系，每个神祇都管理着一项专门的业务。宙斯是天空之神，赫拉是婚姻和家庭女神，波塞冬是海洋之神，哈迪斯是冥府之神，雅典娜是智慧女神，阿波罗是光明之神，阿耳忒弥斯是月亮女神，阿瑞斯是战争之神，阿佛洛狄忒是爱与美的女神，等等。因此，整个宇宙是被神明所主宰的世界，神明管理着宇宙中的各种事务和规律，大到太阳月亮的运行，小到一滴水的流动，无不在神明的掌握之中。即使在现代社会中，绝大部分人已经不再相信有神的存在，然而世界仍然被物理定律所主宰，创造这些物理定律的又是谁呢？有人相信科学的尽头就是神学，一定有一个第一推动，那就是我们这个宇宙的神。

撇开神明不谈，在现代社会中，我们仍然被各种各样的规则所管理。一个人从小到大，都处在无时无刻的监管之中。在家要听父母的话，在学校要遵守学校的制度，进入社会要遵守社会的游戏规则和各种规章制度，死亡之后连骨灰都要被安排得明明白白。一个人的一生，几乎被完全地计划好，在何时该做什么都已经被规定，每一个人都只是在这样的框架下按部就班。如果有人做了出格的事情，比如盗窃、杀人，就会有法律来惩罚他。也许在小范围内，不同的人有不同的样子和稍有差异的生活，但是，在大范围内，所有人都有着同样的思想、行为模式和生活方式。人虽自称为万物之灵，生来自由，却无往不在枷锁之中。正因为有这样的枷锁，人类才构建出这样的文明和社会，是好是坏，本人不敢妄下结论。至少，从全局观察，一套良好的规则是构建一个规范社会的必须。

在我看来，一个程序也是一个有规则的世界。在程序中也需要类似神一样的管理者，管理者其他所有的组件，它们组成了程序这个世界的基础架构。而其他组件则在这些基础架构中运行，来来去去，创建又销毁，就像人出生又死亡。在这些组件的生命过程中，处理各种各样的业务和数据，达成程序设计之初所规定的目标，这些组件也完成了它们的生命价值，就像人一样，然后死去。程序中的一切都被设计好了，所有的组件按照预定的过程工作，完成这个程序被赋予的使命。而我们软件工程师就是程序的创世神，我们创造了这个程序世界的一切。我们设计了类似于神祇的管理者来管理这个程序世界的生命过程，然后创造了一个个具体的组件来丰富这个程序世界，达成我们的目标。我们对其中的每一个对象都充满爱意，就像自己的孩子一样。虽然，我们是这个程序世界的创世神，然而我们不过是另一个世界中的一个普通人，我们也会犯错。如果我们的程序世界出了错，那么整个世界就崩溃了，好在这个程序世界可以被修正和重启。我们可以一次次尝试让这个程序世界变得更加稳定和美好。当一切都被妥善安排和管理，这个程序世界就会像我们希望的样子一直运行下去。有可能比我们这些创世神的生命都长久。

好了，说了这么多。我的目的主要是说明程序也应该像真实的世界，甚至是神话的世界一样被规范设计。定义一系列的规则，让所有的组件都按照这些规则运行。有一部分组件是管理者，它们管理着其他组件，有一部分组件是处理业务和数据的，它们是实现这个程序世界功能的主力。其中的每一个组件都应该被明确定义，定义它的功能和边界，和其他组件区分开。这样，我们软件工程师才能更好地开发程序。当一切都处于混沌状态的时候，即使是神也不能做任何事情。因此，神才要创造世界，将一切从混沌中脱离出来，成为真正的世界。

### 关于软件设计
程序最基本的结构就是一组操作，对这组操作输入一组数据，然后输出一组数据。也就是对数据进行处理的一种方式。数学公式都是程序，对一般人来说最简单的程序可能就是`1 + 1 = 2`这样的数学公式。之后，发展出了更复杂的程序，处理各行各业的业务。也有专门针对数据进行管理的程序。如今，我们的社会被软件主导着，手机、电脑、机器、汽车，无一不是通过程序控制的。程序在我们的生活中无所不在。基本上，程序可以划分为`操作 + 数据`。因此，最简单的做法就是对操作和数据进行分开管理。也就是很多软件设计中的分层思想。基本上会分成`数据层 、业务逻辑层、显示层`，这是最简单最基本的划分方法。当然，里面每一层还可以继续细化，根据具体的业务场景划分出更多的层次。但是，层次不宜过多，太多的层次会导致混乱和难以管理。每一个层次都应该是高内聚的，和其他层次低耦合。专门处理自己内部的细节而不必考虑其他层次的情况，相互之间通过接口通信。

另外，在具体的程序设计中，有些组件是管理者，有些组件是业务员。管理者管理其他组件，业务员处理具体的业务和数据。各司其职，共同完成程序的设计目标。

因此，根据以上的层次划分和组件分类进行程序中各种组件的设计工作。

## 软件层次结构
该项目的层次结构主要分为：数据层、业务层、界面层。  

* 软件层次结构：  
![软件层次结构](./Docs/软件层次结构图/主体类别.png)

* 类别说明：  
![类别说明](./Docs/软件层次结构图/类别说明.png)

* 数据结构：  
![数据结构](./Docs/软件层次结构图/数据结构.png)

* 软件结构：  
![软件结构](./Docs/软件层次结构图/软件结构.png)

### 数据层
* 数据：Datas  
	1. 数据就是信息的载体，描述事物的某一项具体的信息，比如一个人的身高xxx米，体重xxx千克。身高和体重都是一个数据。
	2. 可以是数据库中的某个字段，沙盒中的某个文件，plist中的某个value等。

* 数据源：DataSource  
	1. 持久化存储数据的地方，常见的数据源有：数据库、沙盒文件、缓存、配置文件、CoreData等。
	2. 一定是持久化储存数据的地方，对每一类数据源都有对应的读写方法。比如数据库通过SQL，配置文件通过NSUserDefaults，沙盒文件通过FileManager等。
	3. 对于不同类型的数据源，如果有特定的读写库，那么使用合适的读写库。比如FMDB、Realm、NSUserDefaults、CoreData等。基本上每一种持久化数据源都会有相应的读写库，包括在基础读写功能上封装的库。
	4. 数据源可提供一组验证方法，保证只能有特定的对象访问数据源。

* 数据存取器：DataAccessor
	1. 数据存取器是直接和数据源交互的对象，并且数据源只能和数据存取器交互。
	2. 数据存取器应根据具体的业务需求定义可在数据源中读写的数据。在这一层需要定义最基本的数据类型和字段，比如用户信息需要定义出用户信息的各个字段：id、姓名、年龄、身高、体重、籍贯、住址等。
	3. 数据存取器和数据源通过数据源定义的读写方法交互。数据存取器和上层的数据容器传递的是数据模型。
	4. 也可根据具体需求提供字段级别的细粒度读写操作，比如应用的配置信息，一般都是以单独的字段出现。
	5. 数据存取器可提供一组验证机制，保证只能有特定的通过验证的对象访问数据存取器。
	6. 数据存取器要维护数据源的版本，比如数据库版本升级等。
	7. 数据存取器是代码中需要自定义的最基础的业务结构，定义和管理所有的数据模型。
	8. 数据存取器不应该修改任何数据，只进行读写和数据验证。

* 数据模型：DataModel  
	1. 承载数据的具体类型，可以是类或结构体。
	2. 可以继承自第三方框架，比如JSONModel、MJExtension等。
	3. 如果是类，必须实现copy和mutableCopy方法，以便在容器中拷贝的时候进行深拷贝。
	4. 提供和自身数据相关的一些方法。

* 数据容器：DataContainer  
	1. 所有内存中的数据模型都会保存在数据容器中。
	2. 数据容器向下主要对接数据存取器，数据模型在两者之间传输。
	3. 数据容器向下和向上传输的数据模型总是拷贝的。保证数据的唯一性，防止在无意中被修改。
	4. 数据容器有原始存储区、缓冲区等。缓冲区主要和上层业务逻辑对接。原始存储区和下层数据层对接。当上层业务修改了数据之后，先保存在缓冲区中，然后通过统一的方法写入原始存储区和数据源中。
	5. 数据容器管理一部分从网络或其他非本地途径获取的数据，包括下载数据和提交数据。（还没考虑清楚是否只管理本地数据源的数据）
	6. 对上层提供可使用数据的枚举类型和相关信息。
	7. 提供获取数据的方法、提交修改的方法、写入数据源的方法。单独修改某个字段的方法，修改整个数据模型的方法，通用修改方法等。
	8. 每一种数据容器管理一类有关联关系的数据。这些数据可能来自不同的数据源，大部分情况下是来自相同的数据源。
	9. 多个不同的数据容器管理的数据可能来自相同的数据源，比如都来自数据库，数据库中有很多类别的数据，用户数据和订单数据分别被不同的数据容器管理。
	10. 多个不同的数据容器可相互配合进行数据交互。该逻辑也可放在上层业务逻辑中处理。根据实际情况处理。保证代码整理的逻辑完整性和面向对象的特性。
	11. 根据业务逻辑对数据进行初步的校验，比如修改数据时非空判断，正则校验等。
	12. 当数据量少的时候，也可考虑使用全局单一的数据容器。
	13. 有一个监控器管理所有的数据容器，通过key值获取对应的数据容器。

* 数据校验器：DataChecker  
	1. 根据业务逻辑校验数据的完整性。比如非空、正则校验、格式校验等。
	2. 有小部分和数据模型关联非常强的校验逻辑可放在数据模型中实现。
	3. 可以有一个或多个数据校验器，建议一个数据校验器校验和某个业务相关的一组数据。
	4. 数据校验器之间可以互相调用。
	5. 数据校验器主要被数据容器和数据存储器调用。数据容器主要校验业务逻辑，数据存取器主要校验基本数据的完整性。

* 文档对象：Document  
	1. 对于文档类应用，有专门的文档对象来管理文档数据。一般一组类型的文档对应一个文档对象。比如txt文件、doc文件、pdf文件、dwg文件、psd文件等。
	2. 文档数据包括元数据、文档内容、配置信息等。
	3. 元数据是描述文档内容的数据，比如字体、颜色、阴影等。
	4. 文档内容是文档的实际内容，比如一段文本、一幅图像等。
	5. 配置信息是显示这个文档或文档工具的相关信息，比如界面布局、打印机设置等。
	6. 文档对象通过一个或多个数据容器来组合成一个文档并管理。
	7. 文档对象封装数据容器的细节，对外暴露可操作的文档内容和可执行的操作。
	8. 文档对象可以有一个父类，因为在一个软件中，大部分文档的处理方式有共通点。比如Word可以编辑doc文件和txt文件。对于某些文件类型的特殊处理方式可以子类化文档对象，充分利用面向对象的特性。

### 业务层
* 监控器：Monitor  
	1. 监控所有其他组件的运行状态。比如，管理业务逻辑的Manager，DataAccessor、DataContainer、DataChecker、Document、Handler、Worker、Monitor。
	2. Monitor是其他所有类型组件的监控器。可以从对应类型组件的监控器获取到任意的组件，不过不一定能够访问。取决于那个组件是否有验证。
	3. 监控器的主要任务是监控和管理其他组件的运行状态，随时查看，内存管理，在适当的时候释放某个不再使用的组件。将整个程序的运行状态都管理起来。
	4. 有一个根监控器，用来监控所有其他监控器。从这个根监控器出发，可以遍历所有程序中运行的组件。
	5. 提供查看历史组件的功能，比如有的控制器被创建后被释放，内存中不再存在。但是可以从对应监控器的历史记录中找到存在的记录。
	6. 监控器主要针对程序中的重要类别的监控。一些小的UI组件用Manager管理。比如Toast和Alert。
	7. 所有监控器都是单例的。

* 操作器：Handler  
	1. 操作器和文档对象配合使用，当上层逻辑要操作文档时，通过操作器来操作文档，读取、修改等，改变文档的设置和样式，打印样式，页面布局等。
	2. 操作器对上层逻辑暴露可对文档对象操作的接口，封装文档内容的细节。不需要知道文档的存储结构等。
	3. 操作器要提供对文档内容的描述和定位。比如用户在某个图层上新增一个图形，操作器要提供被操作的图层标识，新增的图形对象和位置，也就是定位出在哪里修改了文档，提供一个定位器。
	4. 操作器像是一个文档对象的游标。每次读取和修改文档对象，游标都要定位到文档的具体位置，然后将修改的内容写入文档对象。并缓存修改的上下文，以提高下次访问的速度。
	5. 每次修改，操作器都要给上层返回被修改的内容和修改的内容。相当于对当次修改做一个快照。操作器应该可以从某一个快照恢复状态。相当于历史记录功能，方便返回上一次的状态。
	6. 更多功能...

* 适配器：Adapter  
	1. 适配器主要和外部组件对接。比如蓝牙模块、网络模块、第三方组件、支付、社会化、IM等。
	2. 主要目的是为了让外部组件能够和本地程序配合工作，将外部组件的接口适配到符合本地程序的业务逻辑中。比如社会化，外部组件只提供最基本的分享接口，适配器要组合本地业务逻辑和分享内容传输给分享接口。比如网络接口，网络模块只提供接口调用和返回数据的功能，适配器要将业务逻辑包含的接口全部实现并返回对应的数据模型，简化入参和出参的解析，业务层只需调用适配器中的方法即可，不需要关注参数的构造和返回数据的解析。

* 管理器：Manager  
	1. 承载业务逻辑的主要对象。针对具体的业务逻辑，创建相对应的管理器。根据业务逻辑细分，不设置具体的限制，但是一定是Manager。
	2. 本地数据存储和DataContainer对接，网络数据和网络适配器对接。其他功能和其他类别的组件对接。
	3. 管理器相当于一个集中所有功能的地方，所有的业务逻辑都会在这里实现。
	4. 还有一类管理器是管理其他组件的，比如状态管理器、弹框管理器、提示管理器等。
	5. 有些全局的管理器要设计成单例的，比如用户管理器、商品管理器。
	6. 有些局部的管理器设计成实例的，在一定范围和业务场景下创建，退出这个场景后被销毁。

* 修饰器：Embellisher  
	1. 修饰器主要用于数据输出到界面或控制台时进行格式化，还包括各种类型之间的转换。比如字符串转数字，时间字符串转日期，日期转特定格式的字符串等。
	2. 针对不同类型的数据，可以有不同的修饰器。比如时间日期修饰器、字符串修饰器等。
	3. 也可根据业务逻辑对某一业务相关的数据建立对应的修饰器，比如电商的价格显示相关修饰，也可根据模块划分。一般这类修饰器比较复杂，需要修饰一组复杂的数据。
	4. 总之一个修饰器是相关的一组业务数据的修饰工具，并且可以互相调用。

* 工作者：Worker  
	1. 工作者是业务流程的基本管理单元。是对其他组件的功能的组合和调用。本身并不定义新的业务逻辑和功能，而是对业务逻辑进行流程化执行。
	2. 在app中，每一个控制器可以对应一个或多个工作者，也可以不对应工作者，根据业务的复杂程度斟酌。和界面无关的逻辑和状态都在工作者中处理，控制器只处理界面显示和用户操作。
	3. 以前很多写在控制器中的方法都会放到工作者中。
	4. 建立工作者的主要目的是剥离和界面无关的功能，专注业务逻辑。即使以后界面改动，也可以用同样的工作着适配新的界面，而不是删掉重写。
	5. 一个工作者并非只对应一个界面，一个工作者一般处理一个完整的不可细分的业务流程。比如登录流程、注册流程、购买一个商品流程、完善个人信息流程等。工作者会记录流程中的状态，因为管理器是全局的，主要负责特定的业务逻辑的管理，并不会记录单个流程的状态。
	6. 一个界面可以对应一个或多个工作者，也可以不对应工作者，如果一个业务流程需要多个界面配合完成，那么强烈建议使用工作者管理流程。如果界面只是用于展示数据，并无复杂数据交互，出于简化代码结构的目的可以不创建工作者。一般情况下建议一个控制器至少对应一个工作者。
	7. 一个控制器可以同时调用多个工作者，工作者之间也可以互相调用。

* 工具集：Tools  
	1. 提供一些便利的工具方法，比如获取沙盒文件路径等。

### 界面层
* 控制器：Controller  
	1. MVC模式下的视图控制器，主要控制视图，完全和业务逻辑无关，业务逻辑都在工作者中，一个控制器会关联一个工作者。
	2. 管理视图状态，控制界面跳转逻辑。

* 视图：View  
	1. 显示数据和接受用户操作的主体。
	2. 显示文本、图像、动画、视频等，输出内容的主要场所，用户输入的主要场所。
	3. 多利用组件。

* 指令调度器：CommandDispatcher  
	1. 对于控制台程序，有一个指令调度器对输入的指令做处理。
	2. 需要定义好所有的指令对象和参数。
	3. 指令调度器是控制台和程序的接口，接受用户输入并调用程序功能然后返回输出。

* 输入输出控制器：InoutController  
	1. 对于控制台程序，在控制台进行输入和输出。相当于用户界面的View。
	2. 格式化输出，格式化输入。

### 代码规范和约定
介绍一下这个项目中的一些代码规范和约定。

#### 目录结构
* OriginObject：最初的对象和工具
* BasicObject：基于本项目的基础对象和工具
* Interface：界面组件
* ViewComponents：视图组件
* Storyboard：故事板
* Packages：功能包
	* Worker：工作者
	* Embellisher：修饰器
	* BusinessManager：业务管理器
	* ComponentManager：组件管理器
	* Adapter：适配器
	* Handler：操作器
	* Document：文档对象
	* DataContainer：数据容器
	* DataChecker：数据校验器
	* DataAccessor：数据存取器
	* Datas：数据模型
	* ThemePackage：主题包
* Components：非UI组件
* Tools：工具集
* Consts：常量定义
* Resources：资源文件
* 3rd：第三方组件
* Others：其它

主要业务功能都在`Packages`目录下，控制器和界面都在`Interface`目录下。这两个是主要开发的目录。

#### 代码规范
* 代码规范基本上参考通用的代码规范即可。驼峰命名法等。
* 多写注释。可参考项目中注释编写规则。
* 一个方法至少在方法名上方写一个注释。
* 一个变量或属性至少写一个注释。
* 一个类或结构体的可供外部调用的接口方法写在一个`extension`中，并实现`ExternalInterface`空协议。
* 一个类或结构体实现的代理方法或者通知等方法写在一个`extension`中，并实现`DelegateProtocol`空协议。
* 一个类或结构体的内部类型写在一个`extension`中，并实现`InternalType`空协议。
* 一个类或结构体为了扩展功能而实现的协议写在一个`extension`中，并实现`InterfaceProtocol`空协议。
* 数据模型以`xxxModel`形式命名。
* 创建的任何类都以所属类别结尾，比如：`xxxManager`、`xxxAdapter`、`xxxViewController`、`xxxView`、`xxxAccessor`等。
* 创建的任何代理方法都以该类型名开头，并遵循驼峰命名法。
* 每个方法之间空1行，类型或扩展之间空2行。同一个类型中不同功能分组的属性之间空一行，并以注释分隔。同一组功能的属性可以不空行或者空一行，以阅读清晰明确为标准。
* 类型中的方法和属性之间空2行，属性定义在类型的最上面。可用注释标记分隔。
* 接口方法注释的斜杠打3个`///`，系统可以自动识别注释内容并在调用时显示。
* 不需要开放给外部程序调用的方法或属性用`fileprivate`修饰。
* 属性定义在类本身中，计算属性定义在扩展中。

### 组件简介
下面介绍这个项目中已经添加的一些组件和功能，这个列表可能还会持续增加。

#### OriginObject
最初的工具和组件，主要是程序中组件的基类和基本数据结构

* `OriginTool`
	* OriginDefine：最初的定义和常量
	* FSQueue：队列容器，先进先出
	* FSStack：栈容器
	* FSVector：向量容器
	* StatusManager：状态管理器
* OriginModel：数据模型基类
* OriginMonitor：监控器基类
* OriginAccessor：数据存取器基类
* OriginChecker：数据校验器基类
* OriginContainer：数据容器基类
* OriginDocument：文档对象基类
* OriginHandler：操作器基类
* OriginAdapter：适配器基类
* OriginManager：管理器基类
* OriginEmbellisher：修饰器基类
* OriginWorker：工作者基类
* `Monitor`
	* MonitorMonitor：监控器监控器
	* AccessorMonitor：数据存取器监控器
	* CheckerMonitor：数据校验器监控器
	* ContainerMonitor：数据容器监控器
	* DocumentMonitor：文档对象监控器
	* HandlerMonitor：操作器监控器
	* AdapterMonitor：适配器监控器
	* ManagerMonitor：管理器监控器
	* EmbellisherMonitor：修饰器监控器
	* WorkerMonitor：工作者监控器

#### BasicObject
针对本项目的基础定义，包括基础控制器和常量等

* `BasicTool`
	* BasicDefine：项目中的一些基础定义
	* NSObject+PropertyListing：NSObject对象属性复制扩展
* AppDelegate
* SceneDelegate
* BasicViewController：所有普通控制器都继承这个基类
* BasicTableViewController：所有tableview控制器都继承这个基类
* BasicNavigationController：所有导航控制器都继承这个基类
* BasicTabbarController：所有tabbar控制器都继承这个基类

#### Interface
所有界面和控制器都放在此处，根据业务需求划分模块文件夹，比如`HomeInterface`、`MineInterface`等。此处仅作参考示例：

* `Interface`
	* `HomeInterface`
		* `Models`：数据模型目录，`xxxModel`等
		* `Views`：视图目录，`UITableViewCell`等
		* MainTabbarController
		* HomeNavigationController
		* ViewController
		* HealthCodeViewController
		* PlaceCodeViewController
        * TravelCardViewController
        * JCollectionViewController
        * ThemeSelectViewController
        * ModalTestViewController
        * ConstraintTestViewController
        * SimpleTableViewController
        * ShadowTestViewController
        * AnimationDemoViewController
        * TestWebViewController
        * DrawTestViewController
        * CopyPasteViewController
        * iCloudFileViewController
        * EditiCloudFileViewController
        ...
	* `MineInterface`
		* `Models`：数据模型目录，`xxxModel`等
		* `Views`：视图目录，`UITableViewCell`等
		* MineNavigationController
		* MineViewController
		* SystemSettingViewController
        ...

#### ViewComponents
全局通用的视图组件，一般是针对本项目的自定义通用组件

* `Base`：此处放置可作为基类的视图组件
* FSDialog：通用弹窗基类
* FSAlertView：通用弹框
* FSActionSheet：通用底部菜单
* FSLabel：带有长按弹出工具条的Label
* FSImageView：带有长按复制图片的ImageView
* FSGuideView：新手引导组件
* SimpleTableView：简单表格
* FSTextField：自定义文本输入框
* FSTextField+ChangeBlock：自定义文本输入框扩展
* CountDownButton：倒计时按钮
* UIButton+ButtonBlock：为UIButton添加block点击事件
* DemoTopSelectBar：测试用顶部选择条
* TeenagerModeDialog：青少年模式弹窗

#### Storyboard
此处放置根据模块划分的storyboard文件

* LaunchScreen
* Main
* Mine

#### Packages
大部分组件功能都在此处定义，针对不同的类别分别创建目录，如果有一个功能内聚的包包含多个组件，那么将它们放在一个目录下，作为一个整体，目录以`xxxPackage`形式命名。

* `Worker`
	* RegisterLoginWorker：注册登录工作者
* `Embellisher`
    * StringEmbellisher：字符串修饰器
    * TimeEmbellisher：时间修饰器
    * PriceEmbellisher：价格修饰器
* `BusinesssManager`
	* UserManager：用户管理器
    * EncryptManager：加密管理器
	* NotificationManager：App内自定义通知管理器
	* SettingsManager：系统设置管理器
	* GuideManager：新手引导管理器
	* LogManager：日志管理器
* `ComponentManager`
	* ApplicationManager：应用程序管理器
	* ControllerManager：控制器管理器
	* ToastManager：toast管理器
	* AlertManager：弹框和模态窗口管理器
	* DialogManager：弹窗管理器
	* ThreadManager：多线程管理器
	* TimerManager：定时器管理器
	* AnimationManager：动画管理器
	* GraphicsManager：绘图管理器
    * HomeShortcutManager: 主屏幕快捷按钮管理器
    * MenuinteractionManager：应用内菜单管理器
* `Adapter`
	* NetworkAdapter：网络适配器
	* WebAdapter：H5页面适配器
    * UrlSchemeAdapter：urlscheme适配器
	* BluetoothAdpater：蓝牙适配器
    * SocializeAdapter：社会化适配器
    * iCloudAdapter：iCloud适配器
    * FileManageAdapter：文件管理适配器
	* NotificationAdapter：系统推送通知适配器
	* CalendarAdapter：系统日历和提醒事项适配器
    * ClipboardAdapter：剪贴板适配器
    * CommunicationAdapter：交流适配器
* `Handler`
* `Document`
* `DataContainer`
	* DatasContainer：通用数据容器
	* DatasConst：数据容器常量定义
* `DataChecker`
    * DatasChecker：数据校验器
    * CheckerConst：校验器常量定义
* `DataAccessor`
	* PlistAccessor：plist文件存取器
	* SandBoxAccessor：沙盒文件存取器
	* UserDefaultsAccessor：UserDefaults存取器
	* DatabaseAccessor：数据库存取器
    * KeychainAccessor：钥匙串存取器
* `Datas`
	* UserInfoModel：用户信息数据模型
	* HomeDataModel：首页数据模型
* `ThemePackage`：主题功能包
    * ThemeManager：主题管理器
    * ThemeContainer：主题容器
    * ThemeProtocol：主题协议
    * ThemeModel：主题数据模型
    * ThemeConst：主题常量
    * Resource：主题资源文件
* `IOPackage`：输入输出包
    * IOManager：输入输出管理器
    * IOChecker：输入输出校验器
    * IOEmbellisher：输入输出修饰器
    * CommandManager：指令管理器
    * CommandConst：指令常量

#### Components
其它非UI组件

* OCUtility：OC工具集
* WeakArray：弱引用数组
* WeakSet：弱引用集合
* WeakDictionary：弱引用字典
* FSException：异常对象

#### Tools
工具集

* Utility：通用工具集，一般是将调用较麻烦的方法缩短，提供更加便利的调用方式。
* NumberTool：数字工具集
* TimeTool：时间日期工具集
* DeviceTool：设备相关工具集
* UnitTool：物理单位工具集
* SystemExtension：系统组件扩展，String/Array/Dictionary等
* UIExtension：系统UI组件扩展，UIView/UIViewController/UIColor等

#### Consts
常量定义

* MacroConst：项目中全局常量和配置，比如全局通知、全局错误和异常、正则表达式等
* StringConst：文案定义，项目中文案/常用特殊字符/希腊字母/数字/数学符号等
* ColorConst：颜色定义
* ImageConst：图片定义
* AudioConst：音频定义
* VideoConst：视频定义
* OCConst：OC头文件引用和宏定义

#### Resources
资源文件

* `BigImages`：一些大图
* `Sounds`：音频文件
* `Videos`：视频文件
* `lotties`：lotties动画文件
* `Assets`：图标和颜色
* `InfoPlist`：系统info.plist文件字段国际化
* `Localizable`：自定义文案国际化

#### 3rd
第三方组件和库

* WebViewJavascriptBridge：webview js交互桥接
* BCCKeychain：系统钥匙串交互
* MPITextKit：富文本组件
* DateTools：时间日期工具
* SSZipArchive：解压缩工具
* SocketRocket：socket库
* CocoaAsyncSocket：socket库
* YYImage：本地图片加载库
* TYAttributedLabel：富文本Label组件
* pop：pop动画库
* lottie-ios：lottie动画库
* NSString+DES：字符串DES加密库
* BAButton：UIButton扩展
* TABAnimated：骨架图
* SQLCipher：数据库加密
* fmdb：SQLite数据库访问
* UIView+Extension：UIView扩展
* SnapKit：swift代码约束库
* SVProgressHUD：Toast组件
* MBProgressHUD：Toast组件
* SDWebImage：网络图片加载库
* Hpple：XML和HTML解析库
* GDataXMLNode：XML解析库
* MJExtension：JSON转Model库
* AFNetworking：网络请求库
* Alamofire：网络请求库

#### Others
其它文件

* Info.plist：工程配置文件
* OCHeader：OC头文件引用
* FrameworkStruct-Bridging-Header：OC和swift桥接文件

#### Docs
文档目录
