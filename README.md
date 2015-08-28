swift-KRHebbian-Algorithm
=========================

## What is it ?

KRHebbian is a self-learning algorithm (adjust the weights) in neural network of Machine Learning (自分学習アルゴリズム).

#### Podfile

```ruby
platform :ios, '8.0'
pod "Swift+KRHebbian", "~> 1.1"
```

## How To Get Started

``` swift
class ViewController: UIViewController {
    
    let krHebbian : KRHebbian = KRHebbian.sharedAlgorithm;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        runHebbian();
        transposeMatrix();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func runHebbian()
    {
        let weights1 : [Float]     = [0.5, 0.0, -1.0, 1.0];
        var initialWeights : [Any] = [weights1];
        
        let x1 : [Float] = [0.0, 1.5, -2.0, 1.0];
        
        krHebbian.theta   = 1.0;
        krHebbian.weights = initialWeights;
        krHebbian.params  = x1;
        krHebbian.training();
        
        println("( Hebbian Retults ) Adjusts next Weights : \(krHebbian.deltaWeights)");
    }
    
    //轉置矩陣
    func transposeMatrix()
    {
        let row1 = [1, 2, 3];
        let row2 = [4, 5, 6];
        let row3 = [7, 8, 9];
        var rows : [Any] = [row1, row2, row3];
        
        var _transposedMatrix = krHebbian.transposeMatrix( rows );
        println("_transposedMatrix : \(_transposedMatrix)");
    }
    
}
```

## Version

V1.1

## Changelogs

V1.1 supported Swift 2.0.

## LICENSE

MIT.

