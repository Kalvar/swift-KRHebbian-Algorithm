swfit-KRHebbian-Algorithm
=========================

## What is it ?

iOS 8 swift with KRHebbian ( Hebbian ) is one of learning rules of adjusting weight in neural-network. If you wanna adjust weight in the algorithms of neurl-network ( Ex : BPN ), that you can use this method to adjust the weight everytime.

## How To Get Started

``` swift
class ViewController: UIViewController {
    
    let krHebbian : KRHebbianAlgorithm = KRHebbianAlgorithm.sharedAlgorithm;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runHebbian();
        transposeMatrix();
    }

    func runHebbian()
    {
        //神經元 1 權重（ X 向 ）( W1 )
        let weights1 : Float[]     = [0.5, 0.0, -1.0, 1.0];
        var initialWeights : Any[] = [weights1];
        
        //輸入 X1 向量 ( Y 向 )
        let x1 : Float[] = [0.0, 1.5, -2.0, 1.0];
        
        krHebbian.theta   = 1.0;
        krHebbian.weights = initialWeights;
        krHebbian.params  = x1;
        krHebbian.training();
        
        //訓練結果 : 1 維陣列
        println("( Hebbian Retults ) Adjusts next Weights : \(krHebbian.deltaWeights)");
    }
    
    //轉置矩陣
    func transposeMatrix()
    {
        //這樣會被自動判定成 Int[]
        let row1 = [1, 2, 3];
        let row2 = [4, 5, 6];
        let row3 = [7, 8, 9];
        var rows : Any[] = [row1, row2, row3];
        
        var _transposedMatrix = krHebbian.transposeMatrix( rows );
        println("_transposedMatrix : \(_transposedMatrix)");
    }
    
}
```

## Version

V1.0

## LICENSE

MIT.

