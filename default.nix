{ stdenv, bazel, cudatoolkit, enableGPU ? true, protobuf, numpy, swig,
  fetchFromGitHub, six  }:

let optional = stdenv.lib.optional;
in stdenv.mkDerivation rec {
  name = "tensorflow-${version}";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "${version}";
    sha256 = "0r56ipjhn85gpf3xqkdrs788zpm4qc4p7iyimfqkpjhshf7p6ss7";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ bazel protobuf numpy six swig ] ++ optional enableGPU cudatoolkit;

  configurePhase = ''
    export TF_NEED_CUDA=0
    bash ./configure
    #export CUDA_TOOLKIT_PATH=${cudatoolkit}
  '';

  # configureFlags = if enableGPU
  #                    then ["TF_NEED_CUDA=1" "CUDA_TOOLKIT_PATH=$cudatoolkit"]
  #                    else ["TF_NEED_CUDA=0"];

  buildPhase = ''
    mkdir ./tmp
    TEST_TMPDIR=./tmp bazel build -c opt //tensorflow/cc:tutorials_example_trainer
  '';

  meta = with stdenv.lib; {
    description = "Machine learning toolkit";
    homepage = "https://github.com/tensorflow/tensorflow";
    maintainers = with maintainers; [ jb55 ];
    license = licenses.asl20;
  };
}
